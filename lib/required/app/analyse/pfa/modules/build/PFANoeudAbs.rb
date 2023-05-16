# encoding: UTF-8
# frozen_string_literal: true
=begin
  Pour les couleurs voir : https://legacy.imagemagick.org/script/color.php
=end

require_relative 'constants'

class PFANoeudAbs
  TOPS        = { part: PFA::LINE_HEIGHT,      seq:3*PFA::LINE_HEIGHT,       noeud:3*PFA::LINE_HEIGHT  }
  HEIGHTS     = { part: 80,       seq: 50,        noeud: 50   }
  FONTSIZES   = { part: 10,       seq: 8,         noeud: 7  }
  FONTWEIGHTS = { part:3,         seq:2,          noeud:1     }
  COLORS      = { part:'gray75',  seq:'gray55',   noeud:'gray55' }
  DARKERS     = { part:'gray50',  seq:'gray45',   noeud:'gray45' }
  GRAVITIES   = { part:'Center',  seq:'Center',   noeud:'Center'}
  BORDERS     = { part:3,         seq:2,          noeud:1}

class << self

  def realpos(val)
    (PFA::PFA_LEFT_MARGIN + realpx(val)).to_i
  end
  def realpx(val)
    (val * coef_pixels).to_i
  end
  alias :realwidth :realpx

  # La fin est 120
  # => coef_time * 120 = PFA-WIDTH
  # => coef_time = PFA-WIDTH / 120
  def coef_pixels
    @coef_pixels ||= (PFA::PFA_WIDTH - PFA::PFA_LEFT_MARGIN - PFA::PFA_RIGHT_MARGIN).to_f / 120
  end

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
def initialize(data)
  @data = data
end

def draw_command
  <<-TXT.gsub(/\n/,' ').strip
#{send("lines_for_#{type}".to_sym)}
\\(
-stroke #{COLORS[type]}
-strokewidth #{FONTWEIGHTS[type]}
-pointsize #{FONTSIZES[type]}
-size #{surface}
label:"#{mark}"
-background none
-trim
-gravity #{GRAVITIES[type]}
-extent #{surface}
\\)
-gravity northwest
-geometry +#{left}+#{top}
-composite
  TXT
end #/ draw_command

# La marque pour une partie (un rectangle)
def lines_for_part
  <<-CMD
-background transparent
-stroke #{DARKERS[:part]}
-fill white
-strokewidth #{BORDERS[:part]}
-draw "rectangle #{left},#{top} #{right},#{box_bottom}"
  CMD
end

# La marque pour une séquence (un crochet allongé)
def lines_for_seq
  <<-CMD
-strokewidth #{BORDERS[:seq]}
-stroke #{COLORS[:seq]}
-fill white
-draw "polyline #{left+4},#{top+demiheight} #{left+4},#{bottom} #{right-4},#{bottom} #{right-4},#{top+demiheight}"
#{mark_horloge}
  CMD
end

# La marque pour un nœud (un rond/point)
def lines_for_noeud
  <<-CMD
-strokewidth #{BORDERS[:noeud]}
-stroke #{COLORS[:noeud]}
-fill white
-draw "roundrectangle #{left},#{top} #{right},#{bottom} 10,10"
#{mark_horloge}
  CMD
end

def mark_horloge
  return '' if data[:no_horloge]
  ihorloge = Horloge.new(horloge: horloge_start, top:bottom+2, left:hcenter)
  ihorloge.magick_code
end


def mark  ; @mark   ||= data[:mark] || label  end
def hname ; @hname  ||= data[:hname]          end
alias :label :hname
def type  ; @type   ||= data[:type]           end

# = Méthodes de temps =

def horloge_start
  @horloge_start  ||= (data[:start] * pfa.coef_time).to_horloge
end #/ horloge

# = Méthodes de dimension et position =

def surface
  @surface ||= "#{width}x#{height}"
end

def height      ; @height       ||= HEIGHTS[type]     end
def demiheight  ; @demiheight   ||= height / 2        end
def demiwidth   ; @demiwidth    ||= width / 2         end
def top         ; @top          ||= TOPS[type]        end
def right       ; @right        ||= left + width      end
def bottom      ; @bottom       ||= top  + height     end
def box_bottom  ; @box_bottom   ||= top + 13*PFA::LINE_HEIGHT end
def hcenter     ; @hcenter      ||= left + demiwidth  end
def vcenter     ; @vcenter      ||= top + demiheight  end

# === Valeurs calculées ===
def width
  @width ||= self.class.realwidth(rel_width)
end
def left
  @left ||= self.class.realpos(rel_left)
end
def rel_width
  @rel_width ||= data[:end] - data[:start]
end
def rel_left
  @rel_left ||= data[:start]
end

def part?     ; @is_part    || type == :part    end
# Note : un "noeud système" est un noeud qui n'en est pas un dans le PFA.
#        typiquement, il s'agit du point zéro et du point final, qui délimintent
#        le début et la fin du film.
def system?   ; @is_system  || type == :system  end

def pfa ; @pfa ||= data[:pfa] end

end #/PFANoeudAbs
