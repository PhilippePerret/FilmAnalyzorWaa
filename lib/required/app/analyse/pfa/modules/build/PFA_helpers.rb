# encoding: UTF-8
# frozen_string_literal: true
=begin
  Helpers pour la class PFA
=end
class PFA

# Retourne la commande pour la marque "ABSOLU", de travers, sur le côté du
# paradigme
def mark_pfa_absolu
  mark_pfa(top:top_pfa_relatif - 5*LINE_HEIGHT, left:PFA_LEFT_MARGIN - 60, label:'ABSOLU')
end

# Idem que précédente mais pour la marque "FILM" (pfa relatif au film)
def mark_pfa_relatif
  mark_pfa(top:top_pfa_relatif + 2*LINE_HEIGHT, left:PFA_LEFT_MARGIN - 60, label:'FILM')
end

# Méthode générique pour les deux méthodes précédente
def mark_pfa(data)
  <<-CMD.gsub(/\n/,' ').strip
  \\(
  -size   400x50
  -background none
  -trim
  -pointsize 10
  -stroke gray50
  -fill gray50
  -strokewidth 3
  -rotate -90
  label:"#{data[:label]}"
  -gravity center
  -extent 50x200
  \\)
  -gravity northwest
  -geometry +#{data[:left]}+#{data[:top]}
  -composite
  CMD
end

# Pour dessiner la ligne qui sépare les deux paradigmes
def line_inter_pfas
  <<-CMD.gsub(/\n/,' ').strip
-stroke black
-fill black
-strokewidth 3
-draw "line #{PFA_LEFT_MARGIN},#{top_pfa_relatif} #{PFA_WIDTH-PFA_RIGHT_MARGIN},#{top_pfa_relatif}"
  CMD
end #/ line_inter_pfas



# Code pour les horloges des parties
def horloges_parties
  cmd = []
  cmd << %Q{-stroke gray50 -fill -pointsize 6.5 -strokewidth 2}
  # Pour le paradigme absolu
  decs = [0,30,60,90,120] # on en aura besoin ci-dessous
  decs.each do |dec|
    h = Horloge.new(horloge:realtime(dec).to_horloge, top:self.class.top_horloge_part_absolue, left:realpos(dec), bgcolor:'gray50', color:'gray90')
    cmd << h.magick_code
  end

  #
  # Pour le paradigme RELATIF (propre au film)
  # 
  [ne(:dv), ne(:d2)||ne(:cv), ne(:dn)].each_with_index do |neu, idx|
    next if neu.nil?
    dec = decs[idx+1]
    leftpos = realpos(dec)
    top = self.class.top_horloge_part_relative
    h = Horloge.new(horloge:neu.time.to_horloge, top:top, left:leftpos, bgcolor:'gray20', color:'white')
    cmd << h.magick_code
    # Pour le décalage
    leftdec = realpos(dec + 2.5)
    diff = neu.time.to_i - realtime(dec)
    pref = diff > 0 ? '+' : '−'
    cmd << %Q{-stroke black -fill black -draw "text #{leftdec},#{top+LINE_HEIGHT/5} '#{pref}#{diff.abs.to_horloge}'"}
  end

  return cmd.join(' ')
end #/ horloges_parties

def top_pfa_relatif
  @top_pfa_relatif ||= self.class.top_pfa_relatif
end #/ top_pfa_relatif

end #/PFA
