module FilmAnalyzor
class Analyse

  #
  # Sauvegarde des données de l'analyse
  # 
  def self.save_data(waadata)
    retour = {ok:true}
    data  = waadata['data']
    path = data['path'] || raise("Le chemin d'accès au dossier doit être défini.")
    File.exist?(path) || raise("Le path ''#{path}'' est introuvable…")
    File.directory?(path) || raise("Il faut indiquer le chemin au dossier de l'analyse (''#{path}'' n'est pas un dossier).")
    # 
    # On procède à l'enregistrement
    # 
    data_path  = File.join(path,'data.ana.yaml')
    File.delete(data_path) if File.exist?(data_path)
    File.write(data_path, data.to_yaml)
  rescue Exception => e
    retour[:ok] = false
    retour[:msg] = e.message
    puts "Erreur à l'enregistrement des données : #{retour[:msg]}".rouge
    puts "Data transmises : #{waadata}".rouge
  ensure
    WAA.send({class:'Analyse.current',method:'saveData', data:retour})
  end

  #
  # Sauvegarde du texte de l'analyse
  # 
  # @note
  #   Elle se fait en plusieurs fois, par bout. La première fois,
  #   c'est waadata['first_portion'] qui est défini, les autres fois
  #   c'est waadata['portion_texte']
  # 
  def self.save_texte(waadata)
    retour = {ok:true}
    path = waadata['path']
    texte_path = File.join(path,'texte.ana.txt')
    if waadata.key?('first_portion')
      #
      # Début de l'enregistrement
      # 
      File.delete(texte_path) if File.exist?(texte_path)
      File.write(texte_path, waadata['first_portion'])
    elsif waadata.key?('portion_texte')
      #
      # Portions de texte suivantes
      # 
      File.append(texte_path, waadata['portion_texte'])
    else
      #
      # Problème : pas de texte
      # 
      retour[:ok]   = false
      retour[:msg]  = "Aucun texte n'a été fourni à l'enregistrement…"
    end
    #
    # Retour client
    # 
    WAA.send(class:'Analyse.current', method:'saveTexte', data:retour)
  rescue Exception => e
    retour[:ok] = false
    retour[:msg] = e.message
    puts "Erreur à la sauvegarde du texte : #{retour[:msg]}".rouge
    puts "Data transmises : #{waadata}".rouge
  ensure
    WAA.send({class:'Analyse.current',method:'saveTexte', data:retour})
  end

  #
  # Chargement de l'analyse vers le client
  # 
  # @note
  #   - Si c'est le premier chargement de la journée, on fait un 
  #     backup.
  #   - Peut-être faudra-t-il découpe le texte, comme à l'enregistrement
  #     (mais je ne pense pas, vu ce que supportent les pages HTML)
  # 
  def self.load(data)
    analyse = new(data['path'])
    analyse.make_backup if analyse.backup_required?
    WAA.send(class:'Analyse',method:'onLoad',data:analyse.client_data)
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

  def client_data
    {
      data:   data,
      texte:  File.read(texte_path.gsub(/"/,'__GUIL__')),
    }
  end

  def make_backup
    puts "Backup des données requis".bleu
    #
    # Procéder au backup
    # 
    bkname   = Time.now.strftime('%Y-%m-%d')
    bkfolder = File.join(backup_folder, bkname)
    mkdir_p(bkfolder)
    if File.exist?(texte_path)
      FileUtils.cp(texte_path, File.join(bkfolder,'texte.ana.txt'))
    else
      puts "Aucun fichier texte à sauvegarder…".rouge
    end
    if File.exist?(data_path)
      FileUtils.cp(data_path , File.join(bkfolder,'data.ana.yaml'))
    else
      puts "Aucun fichier de données à sauvegarder…".rouge
    end
    #
    # Enregistrement de la date de dernière backup
    # 
    data.merge!('last_backup' => Time.now.to_i)
    File.write(data_path, data.to_yaml)
  end

  def backup_required?
    last_backup = Time.at(data['last_backup'] || 0).to_i
    now = Time.now
    now_matin = Time.new(now.year,now.month,now.day,0,0,0).to_i
    return last_backup < now_matin
  end

  def data
    @data ||= YAML.load_file(data_path)
  end

  def backup_folder
    @backup_folder ||= File.join(path,'xbackups')
  end
  def data_path
    @data_path ||= File.join(path,'data.ana.yaml')
  end
  def texte_path
    @texte_path ||= File.join(path,'texte.ana.txt')
  end
end #/class Analyse
end #/module FilmAnalyzor
