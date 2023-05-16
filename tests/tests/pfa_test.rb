#
# Pour lancer ce test :
# 
#   - mettre dans Rakefile : t.test_globs = ["tests/tests/pfa_test.rb"]
#   - jouer 'rake test' (ou même seule 'rake')
# 
require 'test_helper'


class PFATest < Minitest::Test

  def setup
    super
    require './lib/required/app/analyse/pfa/PFA'
  end

  def test_production_image
    
    #
    # Les données pour initier le PFA
    # 
    data_pfa = {
      index: 1,
      name:  "PFA du film",
      description: "Description du PFA",
      folder: File.join(ASSETS_FOLDER,'films','film_pour_pfa'), # dossier dans lequel mettre les images
      #
      # Pour mettre les nœuds dramatiques
      # 
      noeuds: {
        zr: {start_time: 12},
        ex: {start_time: 12,   end_time: 2000, description: "L'exposition du film"},
        id: {start_time: 1000, end_time: 1200, description: "Incident déclencheur du film"},
        p1: {start_time: 1800, end_time:2000, description: "Premier pivot du film"},
        dv: {start_time: 2000, end_time: 6000, description: "Le développement du film"},
        d2: {start_time: 4000, end_time: 6000, description:"Deuxième partie de développement"},
        p2: {start_time: 5800, end_time: 6000, description: "Pivot 2 du film"},
        dn: {start_time: 6000, end_time: 7000, description: "Le dénouement du film"},
        cx: {start_time: 6500, end_time: 6800, description: "Climax du film"},
        pf: {start_time: 7000}
      }
    }
    # ON passe les temps en minutes (qui est l'unité de PFA)
    data_pfa[:noeuds].each do |kn, dn|
      dn.merge!(start_time: dn[:start_time].to_f / 60) unless dn[:start_time].nil?
      dn.merge!(end_time: dn[:end_time].to_f / 60) unless dn[:end_time].nil?
    end

    pfa = PFA.new(data_pfa)
    pfa.build

  end

end #/class PFATest
