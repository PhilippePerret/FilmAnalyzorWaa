#
# Parseur du fichier analyse.ana.txt
# 
# Ce module reçoit un code (ou le path d'un fichier code) et le
# parse pour obtenir les informations de l'analyse, à savoir :
#   - les scènes (avec les temps)
#   - les éléments de description (objectifs, résumés, etc.)
#   - les éléments d'analyse (commentaires sur la scène, etc.)
#   - les éléments structurels (incident perturbateur, climax, etc.)
# 
module FilmAnalyzor
class Analyse
class Parser

  attr_reader :path

  def initialize(path)
    #
    # Si +path+ est un code, on l'enregistre dans un fichier
    # 
    unless File.exist?(path)
      File.write(default_temp_file, path)
      path = default_temp_file
    end
    File.exist?(path) || raise("Le fichier #{path.inspect} est introuvable.")
    @path = path
  end

  REG_TIME = /^([0-9]{1,2})\:([0-9]{1,2})\:([0-9]{1,2})(?:\.([0-9]{1,3}))?$/

  #############################
  ###     Parse du code     ###
  #############################
  def parse
    puts "-> parse"
    init
    current_block = nil
    File.readlines(path).each do |line|
      line = line.strip
      puts "#{line.inspect}.match?(REG_TIME) ? #{line.match?(REG_TIME).inspect}"
      if line.match?(REG_TIME)
        @current_time = h2s(line)
      else
        current_block = parse_line(line.strip, current_block)
        @current_time = nil
      end
    end
    return @parsed_data
  end

  ##
  # Parse d'une ligne
  # 
  def parse_line(line, current_block)
    case line
    when /^SCENE (.*)$/ # Une nouvelle scène
      @current_scene = {time: @current_time, pitch: $1}
    end
    return current_block
  end

  ##
  # Initialisation du parse
  # 
  def init
    @current_scene = {time: 0, pitch: 'GÉNÉRIQUE', resume: '', description:[]}
    @parsed_data = {
      duration: nil,
      scenes: []
    }
  end

  # Reçoit une horloge et retourne un nombre de secondes
  def h2s(h)
    _, hr, mn, sc, fr = h.match(REG_TIME).to_a.map { |n| n.to_i }
    return hr * 3600 + mn * 60 + sc + fr.to_f / 1000
  end

private

  # @prop [String] Fichier par défaut pour mettre le code de
  # l'analyse s'il a été fourni tel quel (et non pas par le path
  # d'un fichier)
  # 
  def default_temp_file
    @default_temp_file ||= begin
      File.join(tmp_folder,"#{Time.now.to_i}.ana.txt")
    end
  end

  def tmp_folder
    @tmp_folder ||= begin
      mkdir(File.join(__dir__,'.tmp'))
    end
  end
end #/Parser
end #/class Analyse
end #/module FilmAnalyzor
