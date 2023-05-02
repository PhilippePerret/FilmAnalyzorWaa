module FilmAnalyzor
class Analyse

  # Pour sauver l'analyse
  def self.save(waadata)
    # puts "data = #{waadata.inspect}"
    retour = {ok:true}
    texte = waadata['texte']
    data  = waadata['data']
    path = data['path'] || raise("Le chemin d'accès au dossier doit être défini.")
    File.exist?(path) || raise("Le path ''#{path}'' est introuvable…")
    File.directory?(path) || raise("Il faut indiquer le chemin au dossier de l'analyse (''#{path}'' n'est pas un dossier).")
    
    # #
    # Tout est bon, on peut enregistrer
    # 
    texte_path = File.join(path,'texte.ana.txt')
    File.delete(texte_path) if File.exist?(texte_path)
    File.write(texte_path, texte)
    data_path  = File.join(path,'data.ana.yaml')
    File.delete(data_path) if File.exist?(data_path)
    File.write(data_path, data.to_yaml)

  rescue Exception => e
    retour[:ok] = false
    retour[:msg] = e.message
    puts "Message d'erreur : #{retour[:msg]}".rouge
  ensure
    WAA.send({class:'Analyse.current',method:'onSaved', data:retour})
  end


  def self.load(data)
    analyse = new(data['path'])
    WAA.send(class:'Analyse',method:'onLoad',data:analyse.data)
  end



###################       INSTANCE      ###################
  
  attr_reader :path

  # @param [String] path Chemin d'accès au DOSSIER de l'analyse
  # @note
  #   Ce dossier devrait contenir :
  #     - analyse.ana.txt     Texte de l'analyse
  #     - data.ana.yaml       Données de l'analyse
  #     - <nom film>.mp4      Fichiers du film
  def initialize(path)
    @path = path
  end

  def data
    {
      data: YAML.load_file(data_path),
      texte: File.read(texte_path.gsub(/"/,'__GUIL__')),
    }
  end

  def data_path
    @data_path ||= File.join(path,'data.ana.yaml')
  end
  def texte_path
    @texte_path ||= File.join(path,'texte.ana.txt')
  end
end #/class Analyse
end #/module FilmAnalyzor
