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
