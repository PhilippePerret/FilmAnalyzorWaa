module WaaApp
class Server

  #
  # Méthode appelée au démarrage (avant le chargement de la page)
  # 
  def self.on_start_up
    #
    # On regarde si le dossier courant est une analyse ou s'il 
    # pourrait être transformé en analyse
    # 
    FilmAnalyzor::Analyse.check_current_folder
    #
    # On détruit les hot-backups trop vieux
    # 
    # @rappel
    #   Les "hot-backups" sont des backups fait à chaque 
    #   enregistrement du texte de l'analyse (contrairement aux
    #   backups normaux qui ne sont fait qu'une seule fois par jour
    #   et sont conservés)
    # 
    FilmAnalyzor::Analyse.remove_old_hot_backups(File.expand_path('.'))
  end

  #
  # Méthode appelée quand on passe en mode test
  # 
  def self.on_toggle_mode_test
    if WaaApp::Server.mode_test?
      puts "L'application passe en mode test.".bleu
    else
      puts "L'application repasse en mode production.".bleu
    end
  end

end #/class Server
end #/module WaaApp
