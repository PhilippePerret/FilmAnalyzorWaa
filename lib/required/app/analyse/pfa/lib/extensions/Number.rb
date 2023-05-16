# encoding: UTF-8
# frozen_string_literal: true
=begin
  Extension de la class Integer
=end

class Integer

  def days
    self * 3600 * 24
  end
  alias :day :days

end

class Float
  # 
  # Transforme l'entier en horloge
  # 
  def to_horloge
    s = (self * 60).to_i
    h = (s / 3600).to_s
    s = s % 3600
    m = (s / 60).to_s.rjust(2,'0')
    s = (s % 60).to_s.rjust(2,'0')
    "#{h}:#{m}:#{s}"
  end
  alias :to_h :to_horloge

end #/Integer
