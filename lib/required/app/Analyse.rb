module FilmAnalyzor
class Analyse

  #
  # Sauvegarde des données de l'analyse
  # 
  def self.save_data(waadata)
    retour = {ok:true}
    data  = waadata['data']
    path = data['path']   || raise("Le chemin d'accès au dossier doit être défini.")
    File.exist?(path)     || raise("Le path ''#{path}'' est introuvable…")
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
    ana  = new(path)
    texte_path = ana.texte_path
    if waadata.key?('first_portion')
      #
      # Début de l'enregistrement
      # 
      # - backup provisoire -
      move_to_hot_backups_folder(texte_path) if File.exist?(texte_path)
      # - écriture dans fichier final -
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

  # Méthode qui permet, au lieu de détruire le texte actuel, de le
  # déplacer vers un dossier backup provisoire qui conserve tous les
  # backups
  # 
  # @params tpath [String] Chemin d'accès au fichier texte de l'analyse
  # 
  def self.move_to_hot_backups_folder(tpath)
    begin
      fname = Time.now.strftime('%Y %m %d %Hh%Mmn%S.ana.txt')
      fold  = File.join(File.dirname(tpath), 'xhotbackups', Time.now.strftime('%Y-%m-%d'))
      `mkdir -p "#{fold}"`
      bpath = File.join(fold, fname)
      FileUtils.move(tpath, bpath)
    rescue Exception => e
      puts e.message.rouge
    end
  end

  # Méthode, appelée au lancement de l'application qui détruit les
  # dossier "hot-backup" trop vieux
  # 
  def self.remove_old_hot_backups(afolder)
    main_folder = File.join(afolder,'xhotbackups')
    return unless File.exist?(main_folder)
    require 'date'
    ilya_trois_jours = Time.now - 3*3600*24
    nombre_detruits = 0
    Dir["#{main_folder}/*"].each do |dossier|
      next unless File.directory?(dossier)
      next if Date.parse(File.basename(dossier)).to_time > ilya_trois_jours
      # 
      # Destruction du dossier
      # 
      FileUtils.rm_rf(dossier)
      nombre_detruits += 1
    end
    puts "Vieux hot-backups détruits avec succès (#{nombre_detruits}).".vert if nombre_detruits > 0
  end

  ##
  # Chargement de l'analyse courante (if any)
  # 
  # Cette méthode est appelée au chargement de l'application (après
  # que tout a été installé et préparé) pour voir s'il y a une analyse
  # courante. Une analyse courante existe :
  #   - si on a lancé l'application depuis un dossier contenant une
  #     analyse (donc le fichier 'data.ana.yaml')
  #   - si une analyse est enregistrée comme dernière analyse effec-
  #     tuée
  # 
  def self.load_current
    anapath = File.absolute_path(File.join('.','data.ana.yaml'))
    if File.exist?(anapath)
      # 
      # On se trouve dans le dossier d'une analyse
      # 

      #
      # On vérifie que l'adresse n'ait pas changé
      #
      analyse = new(File.dirname(anapath))
      if analyse.path != analyse.data['path']
        puts "Le chemin d'accès (data['path']) ne correspond pas. Je le corrige.".jaune
        analyse.data.merge!('path' => analyse.path)
        File.write(analyse.data_path, analyse.data.to_yaml)
      end

      #
      # On charge l'analyse
      # 
      load('path' => File.dirname(anapath))

    elsif last_analyse
      #
      # Chargement de la dernière analyse travaillée
      #
      load('path' => hotdata[:last_analyse_path])

    end
  end

  ##
  # Méthode appelée avant le chargement de la page, qui vérifie le
  # dossier courant, pour savoir si ça peut ou pourrait être une
  # analyse.
  # 
  def self.check_current_folder
    anapath = File.join('.','data.ana.yaml')
    return if File.exist?(anapath) # C'est déjà une analyse
    return if Dir["./*.mp4"].count == 0
    video_name = File.basename(Dir["./*.mp4"].first)
    # - Ça peut être une analyse -
    Q.yes?("Dois-je transformer ce dossier en dossier d'analyse ?".jaune) || return
    titre = Q.ask("Titre du film : ".jaune)
    data = {
      'titre' => titre, 
      'path'  => File.expand_path('.'), 
      'video' => video_name
    }
    File.write(anapath, data.to_yaml)
    txtpath = File.join('.','analyse.ana.txt')
    File.write(txtpath, "# Analyse de #{titre}\n\n")
    puts "Analyse initiée avec succès.".vert

    return 
  end


  def self.last_analyse
    hotdata[:last_analyse_path]
  end
  def self.last_analyse=(path)
    hotdata.merge!(last_analyse_path: path)
    save_hotdata
  end

  # 
  # --- Hot Data Methods ---
  # 
  def self.hotdata
    if File.exist?(hotdata_file)
      YAML.load_file(hotdata_file, **YAML_OPTIONS)
    else
      {}
    end
  end
  def self.save_hotdata
    File.write(hotdata_file, hotdata.to_yaml)
  end
  def self.hotdata_file
    @@hotdata_file ||= File.join(TMP_FOLDER,'hotdata.yaml')
  end

  #
  # Chargement de l'analyse vers le client
  # 
  # @note
  #   - Si c'est le premier chargement de la journée, on fait un 
  #     backup.
  #   - La méthode vérifie que la vidéo existe bien dans le dossier
  #     me/Sites/FilmAnalyzor et, le cas échouant, la copie
  #   - Peut-être faudra-t-il découpe le texte, comme à l'enregistrement
  #     (mais je ne pense pas, vu ce que supportent les pages HTML)
  # 
  def self.load(data)
    # débug
    # puts "Object-Id de la class Analyse : #{self.object_id}"
    # /débug
    analyse = new(data['path'])
    analyse.make_backup if analyse.backup_required?
    analyse.check_video
    last_analyse = data['path'] # pour s'en souvenir
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
    @path = File.expand_path(path)
    @message = nil
  end

  # @return [Hash] Les données à retourner au client
  def client_data
    {
      data:   data,
      texte:  File.read(texte_path.gsub(/"/,'__GUIL__')),
    }
  end

  def check_video
    video_name || raise("Il faut absolument définir le nom du fichier vidéo dans data.ana.yaml s'il ne possède pas le nom par défaut (:video).")
    video_path = File.join(path, video_name)
    video_path_in_sites = File.join(Dir.home,'Sites','FilmAnalyzor',video_name)
    return true if File.exist?(video_path_in_sites)
    #
    # La vidéo n'existe pas dans le dossier Sites. Si elle existe
    # dans le dossier de l'analyse, on la copie
    # 
    if File.exist?(video_path)
      puts "Copie de la vidéo, merci de patienter…".bleu
      FileUtils.cp(video_path, video_path_in_sites)
      puts "Vidéo copiée. Merci de votre patience.".vert
    else
      raise "La vidéo '#{video_path}' est malheureusement introuvable. Je ne peux pas ouvrir cette analyse."
    end
  end

  ##
  # Nom du fichier vidéo
  #   Soit il est défini dans le fichier data.ana.yaml
  #   Soit il porte le nom par défaut qui peut être :
  #     - <nom dossier>.mp4
  #     - <nom dossier>-us.mp4
  #     - <nom dossier>-fr.mp4
  def video_name
    @video_name ||= begin
      data['video'] ||= begin
        dname = File.basename(path)
        vname = nil
        ["#{dname}", "#{dname}-us", "#{dname}-fr"].each do |affixe|
          vname = "#{affixe}.mp4"
          break if File.exist?(File.join(path,vname))
        end
        vname
      end
    end
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
      FileUtils.cp(texte_path, File.join(bkfolder,'analyse.ana.txt'))
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
    @texte_path ||= begin
      oldpath = File.join(path,'texte.ana.txt')
      newpath = File.join(path,'analyse.ana.txt')
      FileUtils.cp(oldpath, newpath) if File.exist?(oldpath) && not(File.exist?(newpath))
      newpath
    end
  end
end #/class Analyse
end #/module FilmAnalyzor
