# encoding: UTF-8
# frozen_string_literal: true
=begin
  
  Module de construction du PFA sous forme d'une image SVG.

=end


class PFA


class << self

def top_pfa_relatif
  @top_pfa_relatif ||= 7 * LINE_HEIGHT
end

# Position verticale (y) des horloges du paradigme absolu
def top_horloge_part_absolue
  @top_horloge_part_absolue ||= top_pfa_relatif - LINE_HEIGHT + 10 # 6*LINE_HEIGHT
end

def top_horloge_part_relative
  @top_horloge_part_relative ||= top_pfa_relatif + 10 # top_horloge_part_absolue + LINE_HEIGHT
end

# Retoure le type :part, :seq ou :noeud en fonction de l'identifiant
# du noeud (par exemple 'id','ip', 'dv', etc.)
def type_of(id)
  id = id.to_sym
  DATA_NOEUDS[id][:type]
end #/ type_of

def mark_of(id)
  d = DATA_NOEUDS[id.to_sym]
  d[:dim] || d[:mark] || d[:hname]
end #/ mark_of

end # /<< self



# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_accessor :noeudsRel
attr_reader :errors, :lakes


###########################
### Construction du PFA ###
###########################
# 
# @public
# @main
# 
# Cette construction doit produire une image de 4000 pixels de large
# sur ? de haut
def build

  construction_possible? || begin
    return erreur("\nLa construction du PFA “#{name}” est impossible. Il manque au moins ces éléments :\n\t#{missing_elements_for_build(as_human = true).join("\n\t")}")
  end

  #
  # On récupère les évènements de type nœud-clé (nc)
  # 
  @noeudsRel = {}
  noeuds.each do |node_type, dnode|
    @noeudsRel.merge!(node_type => PFANoeudRel.new(self, dnode.merge!(type: node_type)))
  end

  prepare_noeuds_abs


  # === CONSTRUCTION ===

  # Si l'image du PFA existe déjà on la détruit.
  File.delete(image_path) if File.exist?(image_path)

  # 'cmd' va contenir tous le code pour construire l'image avec 'convert'
  puts "Dimensions de l'image : #{PFA_WIDTH} x #{PFA_HEIGHT}".bleu
  cmd = ["#{CONVERT_CMD} -size #{PFA_WIDTH}x#{PFA_HEIGHT}"]
  cmd << "xc:white"
  cmd << "-units PixelsPerInch -density 300"
  cmd << "-background white -stroke black"

  # On dessine d'abord le fond, avec les actes
  actes = []
  DATA_NOEUDS.each do |kneu, dneu|
    next unless dneu[:instance].part?
    actes << dneu[:instance]
    cmd << dneu[:instance].draw_command
  end

  # Et on dessine ensuite le contenu ABSOLU des actes, c'est-à-dire les
  # scènes-clés (pivots, incidents, etc.)
  actes.each do |acte|
    acte.data[:inner].each do |kin|
      cmd << noeudAbs(kin).draw_command
    end
  end

  # On ajoute une marque "ABSOLU" et une marque "FILM" + une délimitation
  # pour faire la différence entre le paradigme absolu et relatif
  cmd << mark_pfa_absolu
  cmd << mark_pfa_relatif
  cmd << line_inter_pfas

  #
  # On ajoute des délimitations pour les actes s'ils ne coïncident
  # pas avec les valeurs absolues (à +- 1/24e)
  # 
  [:dv, :d2, :dn].each do |kpart|
    cmd << noeudRel(kpart).draw_command
  end

  #
  # On ajoute les nœuds (RELATIFS) du film qui sont définis
  # 
  [:ip, :id, :p1, :t1, :cv, :t2, :cr, :p2, :cd, :cx, :de].each do |kne|
    next if noeudRel(kne).nil?
    cmd << noeudRel(kne).draw_command
  end


  # On ajoute les horloges des parties, aussi bien absolues que
  # relatives au film.
  cmd << horloges_parties

  # cmd << "-colorspace sRGB"
  cmd << "-set colorspace sRGB"
  cmd << image_path.gsub(/ /, "\\ ")

  cmd = cmd.join(' ')
  res = `#{cmd} 2>&1`

  # On la coupe en deux parties pour la mettre en
  # haut de deux pages qui se font face

  moitieX = (PFA_WIDTH.to_f / 2).to_i
  crop_gauche = "#{moitieX}x#{PFA_HEIGHT}+0+0"
  crop_droite = "#{moitieX}x#{PFA_HEIGHT}+#{moitieX}+0"
  cmd = ["cd '#{File.dirname(image_path)}'"]
  cmd << "#{CONVERT_CMD} pfa.jpg -crop #{crop_gauche} pfa-gauche.jpg"
  cmd << "#{CONVERT_CMD} pfa.jpg -crop #{crop_droite} pfa-droite.jpg"
  res = `#{cmd.join(';')} 2>&1`

  # ==== POST PRODUCTION ===
  
  if File.exist?(@image_path)
    puts "Le PFA a été construit avec succès (dans #{@image_path}).".vert
  else
    puts "Bizarrement, tout semble s'être bien passé mais l'image n'a pas été produite…".rouge
  end


end #/build

# @prop Durée en minutes du film
def duration
  @duration ||= noeud(:pf)[:start_time] - noeud(:zr)[:start_time]
end

def realpos(val)
  (PFA_LEFT_MARGIN + realpx(val)).to_i
end
def realpx(val)
  (val * coef_pixels).to_i
end
alias :realwidth :realpx

# Renvoie le temps qui correspond à la "valeur 120" donnée
def realtime(val)
  val * coef_time
end

# La fin est 120
# => coef_time * 120 = PFA-WIDTH
# => coef_time = PFA-WIDTH / 120
def coef_pixels
  # Pour passer tout en secondes :
  # @coef_pixels ||= (PFA_WIDTH - PFA_LEFT_MARGIN - PFA_RIGHT_MARGIN).to_f / (120 * 60)
  @coef_pixels ||= (PFA_WIDTH - PFA_LEFT_MARGIN - PFA_RIGHT_MARGIN).to_f / 120
end

# La fin est 120
# La durée réelle est real_duree
# Donc : coef_time * 120 = real_duree
# => coef_time = real_duree / 120
def coef_time
  @coef_time ||= real_duree.to_f / 120
end


# La durée "réelle", c'est-à-dire entre le point zéro et
# le point final
def real_duree
  @real_duree ||= duration
end


# Méthode qui retourne true si on peut construire le PFA
def enabled?
  errs = []
  noeudRel(:zr) || errs << "manque le “point zéro”"
  noeudRel(:pf) || errs << "manque le “point final”"
  noeudRel(:ex) || errs << "manque le début de l'exposition"
  if ne(:dv) && ne(:ex)
    bon_ordre?(:ex, :dv) || errs << "le développement commence avant l'exposition…"
  else
    errs << "manque le début du développement"
  end
  if ne(:d2)
    !ne(:dv) || bon_ordre?(:dv, :d2) || errs << "la seconde partie de développement devrait se trouver APRÈS la première…"
    !ne(:ex) || bon_ordre?(:ex, :d2) || errs << "l'exposition devrait se trouver AVANT la seconde part de développement"
  else
    errs << "manque le début de la seconde partie de développement"
  end
  if noeudRel(:dn)
    !ne(:dv) || bon_ordre?(:dv, :dn) || errs << "le dénouement commence avant le développement"
    !ne(:d2) || bon_ordre?(:d2, :dn) || errs << "le dénouement commence avant la part II de développement"
    !ne(:ex) || bon_ordre?(:ex, :dn) || errs << "le dénouement commence avant l'exposition"
  else
    errs << "manque le début du dénouement"
  end
  if ne(:p1)
    !ne(:dv) || bon_ordre?(:p1, :dv) || errs << "le pivot 1 doit se trouver AVANT le développement"
    !ne(:dn) || bon_ordre?(:p1, :dn) || errs << "le pivot 1 doit se trouver AVANT le dénouement"
  else
    errs << "manque le pivot 1"
  end


  if ne(:p2)
    !ne(:dn) || bon_ordre?(:p2, :dn) || errs << "le pivot 2 devrait se trouver AVANT le dénouement"
    !ne(:ex) || bon_ordre?(:ex, :p2) || errs << "le pivot 2 devrait se trouver APRÈS l'exposition"
    !ne(:dv) || bon_ordre?(:dv, :p2) || errs << "le pivot 2 doit se trouver APRÈS le début du développement"
  else
    errs << "manque le pivot 2"
  end

  if ne(:id)
    !ne(:dv) || bon_ordre?(:id, :dv) || errs << "l'incident déclencheur doit se trouver AVANT le développement"
    !ne(:ip) || bon_ordre?(:ip, :id) || errs << "l'incident déclencheur doit se trouver APRÈS l'incident perturbateur"
  else
    errs << "manque l'incident déclencheur"
  end

  if ne(:cx)
    !ne(:dn) || bon_ordre?(:dn, :cx) || errs << "le climax devrait se trouver DANS le dénouement"
  else
    errs << "manque le climax"
  end

  # S'il n'y a pas d'erreurs jusque-là, on peut déjà établir un PFA succinct
  # On vérifie s'il sera complet (self.complet?)
  laks = []
  if errs.empty?
    [:ip, :cv, :cr].each do |k|
      noeudRel(k) || laks << "#{noeudAbs(k).hname}"
    end
  end

  @errors = errs
  @lakes  = laks # les manques pour qu'il soit complet
  return errors.empty?
end #/ enabled?

# Retourne l'instance PFANoeudRel du noeud (existant) de clé +key+
def noeudRel(key)
  noeudsRel[key]
end
alias :ne :noeudRel
alias :nr :noeudRel

# Données absolu du noeud
def noeudAbs(key)
  DATA_NOEUDS[key][:instance]
end
alias :na :noeudAbs

# Chemin d'accès au fichier image du paradigme
def image_path
  @image_path ||= File.join(export_folder,'pfa.jpg')
end

# Méthode qui crée une bonne fois pour toutes les instances de nœuds absolu
# pour renseigner la propriété :instance dans DATA_NOEUDS.
# Ce noeud se récupère à l'aide de la méthode :noeudAbs (ou son alias :na)
# en fournissant la clé. Par exemple :
#   neu = noeudAbs(:ip)
#
def prepare_noeuds_abs
  DATA_NOEUDS.each { |kn, dn| dn.merge!(instance: PFANoeudAbs.new(dn.merge!(pfa: self)))}
end

private

# Renvoie true si le noeud de clé +kav+ se situe bien avant le noeud de
# clé +kap+
def bon_ordre?(kav, kap)
  noeudRel(kav).time < noeudRel(kap).time
end #/ bon_ordre?


private

  # 
  # @return true si la construction du PFA est possible, c'est-à-dire
  # s'il possède les nœuds minimum requis.
  # 
  def construction_possible?
    missing_elements_for_build.empty?
  end

  # 
  # @return [Array] la liste des noeuds requis pour la construction qui sont
  # manquants.
  # 
  # +as_human+  Si TRUE, on renvoie la liste sous forme humaine (pou
  #             un message par exemple)
  # 
  def missing_elements_for_build(as_human = false)
    REQUIRE_NODES_FOR_BUILDING.collect do |etype|
      next if not noeud(etype).nil?
      as_human ? DATA_NOEUDS[etype][:long_name] : etype
    end.compact
  end


end #/PFA
