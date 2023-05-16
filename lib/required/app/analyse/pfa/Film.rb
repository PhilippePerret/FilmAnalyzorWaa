# encoding: UTF-8
# frozen_string_literal: true
#
# Pour compenser l'absence de l'instance Film quand j'ai repris
# le PFA de Analyse_with_VLC
# 
# 
=begin
  
  class Film
  ----------
  Pour la gestion du film courant

=end

# 
# Instance {Film} du film courant
# 
# +params+ est défini lorsque la commande 'film' est invoquée
# 
def film(params = nil)
  Film.current
end


class Film
# -------------------------------------------------------------------
#
#   CONSTANTES FILM
#
# -------------------------------------------------------------------
TYPES_ELEMENTS = {
  'scene' => {id:'scene', name:'scène', Name:'Scène', names:'scènes', Names:'Scènes'},
  'note'  => {id:'note',  name:'note',  Name:'Note',  names:'notes',  Names:'Notes'},
  'info'  => {id:'info',  name:'info',  Name:'Info',  names:'infos',  Names:'Infos'},
  'marque'=> {id:'marque',name:'marque',Name:'Marque',names:'marques',Names:'Marques'},
}
# -------------------------------------------------------------------
#
#   CLASSE
#
# -------------------------------------------------------------------
class << self
  
  def current; @current end
  def current=(film); @current = film end

end #/<< self

# -------------------------------------------------------------------
#
#   INSTANCE
#
# -------------------------------------------------------------------


# @prop Chemin d'accès à la vidéo du film
attr_reader :main_folder

def initialize(path)
  @main_folder = path
end

# 
# Retourne la table des personnages avec en clé l'identifiant du
# personnage et en valeur son instance.
# C'est un simple alias à Personnage.table
# 
def table_personnages
  Personnage.table
end

def infos
  @infos ||= begin
    if File.exist?(infos_path)
      YAML.load_file(infos_path)
    else
      {
        title: nil,
        title_fr: nil,
        authors: nil,
        director: nil,
        types_marques: {},
      }
    end
  end
end

def save_infos(hdata = nil)
  @infos || infos # pour forcer à les charger
  @infos.merge!(hdata) unless hdata.nil?
  File.delete(infos_path) if File.exist?(infos_path)
  File.open(infos_path,'wb'){|f|f.write(YAML.dump(infos))}
end

def hotdata
  @hotdata ||= begin
    if File.exist?(hotdata_path)
      YAML.load_file(hotdata_path)
    else
      {
        last_command: nil,
        last_element_id: 0,
        index_current_pfa: nil,
      }
    end
  end
end

def update_hotdata(hdata = nil)
  hotdata if @hotdata.nil?
  @hotdata.merge!(hdata) unless hdata.nil?
  File.delete(hotdata_path) if File.exist?(hotdata_path)
  File.open(hotdata_path,'wb'){|f|f.write(YAML.dump(hotdata))}
end

# -------------------------------------------------------------------
#
#   ÉLÉMENTS
#
# -------------------------------------------------------------------

# 
# Retourne un nouvel ID universel pour un élément (et enregistre
# la dernière valeur)
# 
def get_new_id
  last_id = hotdata[:last_element_id] + 1
  update_hotdata(last_element_id: last_id)

  return last_id
end

def insert_element(new_el)
  inserted = false
  finales = []
  elements(new_el.type).each do |el|
    finales << el and next if inserted # pour accélérer
    if el.time > new_el.time
      finales << new_el
      inserted = true
    end
    finales << el
  end
  finales << new_el if not inserted

  save_elements(new_el.type, finales)
end

def save_elements(type, liste)
  File.open(elements_file_path(type),'wb'){|f| f.write(YAML.dump(liste.collect{|e|e.data}))}
  @elements.merge!(type => liste)
  LAST_DATE_CHECK.merge!(element_file_name(type) => Time.now.to_i)
end

def elements(type)
  type = type.to_sym
  @elements ||= {}
  @elements[type] ||= begin
    epath = elements_file_path(type)
    if File.exist?(epath)
      LAST_DATE_CHECK.merge!(element_file_name(type) => Time.now.to_i)
      classe = eval(type.to_s.capitalize)
      d = YAML.load_file(epath)
      if d
        d.collect { |de| classe.new(de) }
      else
        []
      end
    else
      []
    end
  end
  
  return @elements[type]
end

# 
# Retourne le chemin d'accès au fichier data des éléments de
# type +type+ (scene, note, etc.)
# 
def elements_file_path(type)
  File.join(folder, element_file_name(type))
end
def element_file_name(type)
  "#{type.to_s}s.yaml"
end


# -------------------------------------------------------------------
#
#   MÉTHODES UTILITAIRES
#
# -------------------------------------------------------------------

# 
# Vérifie que les données sont toujours à jour par rapport au dernier
# temps de sauvegarde
# 
def check_if_outofdate
  update_required = false
  Dir["#{folder}/**/*.*"].each do |fpath|
    fname = File.basename(fpath)
    mtime = File.stat(fpath).mtime.to_i
    # puts "check out-of-date : #{fname} (#{mtime})"
    if LAST_DATE_CHECK.key?(fname)
      if LAST_DATE_CHECK[fname] < mtime
        # puts "#{fname} modifié depuis la dernière sauvegarde => update requis"
        update_required = true
        break
      end
    else
      # puts "LAST_DATE_CHECK[#{fname}] n'est pas défini => update requis"
      update_required = true
      break
    end
  end 

  # 
  # Quand l'actualisation est requise
  # 
  if update_required
    require File.join(COMMANDS_FOLDER,'reset')
    Commande.reset
  end
end


# 
# Effectue un backup des données du film si nécessaire
#
# Note : c'est nécessaire lorsque le dernier backup n'existe pas ou
# remonte à plus de 4 heures
# 
def backup_if_necessary
  backups = Dir["#{backups_folder}/*"].collect do |fpath|
    fname = File.basename(fpath)
    prefix, time = fname.split('-')
    {prefix: prefix, time: time.to_i, fpath: fpath}
  end.sort_by do |db|
    db[:time]
  end.reverse

  now = Time.now.to_i
  ilya4heures = now - 4 * 3600

  if not backups.empty? 
    backups.each do |db|
      # Si un backup a été fait il y a moins de 4 heures, on 
      # peut s'en retourner
      return if db[:time] > ilya4heures
    end
  end

  # 
  # On ne doit garder que les 4 derniers
  # 
  if backups.count > 4
    backups[4..-1].each do |db|
      FileUtils.rm_rf(db[:fpath])
    end
  end
  proceed_backup

end

def proceed_backup
  current_bk_fname = "backup-#{Time.now.to_i}"
  current_bk_fpath = File.join(backups_folder, current_bk_fname)
  FileUtils.cp_r(folder, current_bk_fpath)
end

# -------------------------------------------------------------------
#
#   DATA
#
# -------------------------------------------------------------------

def title
  @title ||= infos[:title]
end
alias :titre :title
# -------------------------------------------------------------------
#
#   PATHS
#
# -------------------------------------------------------------------

# Fichier contenant les données 'hot' (dernier ID d'élément, dernière
# commande jouée, etc.)
def hotdata_path
  @hotdata_path ||= File.join(main_folder,'hotdata.yaml')
end
# Fichier contenant les informations du film
def infos_path
  @infos_path ||= File.join(main_folder, 'infos.yaml')
end
def pfa_folder
  @pfa_folder ||= mkdir(File.join(collecte_folder,'pfas'))
end
def export_folder
  @export_folder ||= mkdir(File.join(main_folder,'export'))
end
def backups_folder
  @backups_folder ||= mkdir(File.join(main_folder,'backups'))
end
def folder
  @folder ||= mkdir(File.join(main_folder, 'collecte'))
end
alias :collecte_folder :folder

end #/class Film
