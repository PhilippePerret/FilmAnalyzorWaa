# encoding: UTF-8
# frozen_string_literal: true

class Horloge

  HORLOGE_WIDTH = PFA::PFA_WIDTH / 35

class << self

end # /<< self

# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
def initialize data
  @data = data
  if !data[:horloge]
    raise "L'horloge doit être défini ! (dans #{data.inspect})"
  end
end #/ initialize


def magick_code
  <<-CMD.gsub(/\n/,' ').strip
\\(
-background #{bgcolor}
-stroke #{color}
-fill #{color}
-strokewidth 1
-pointsize 6.5
-size #{surface}
-gravity Center
label:"#{horloge}"
-extent #{surface}
\\)
-gravity northwest
-geometry +#{left}+#{top}
-composite
  CMD
end #/ magick_code

def horloge
  @horloge ||= data[:horloge]
end #/ horloge

def left  ; @left   ||= data[:left] - HORLOGE_WIDTH/2 end
def top   ; @top    ||= data[:top] end

def bgcolor; @bgcolor ||= data[:bgcolor]  || 'white'  end
def color;   @color   ||= data[:color]    || 'gray20' end

def surface
  "#{HORLOGE_WIDTH}x50"
end #/ surface
end #/Horloge
