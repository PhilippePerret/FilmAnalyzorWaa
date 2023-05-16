#
# Test du parseur d'analyse
# 
require 'test_helper'

class AnalyseParserTest < MiniTest::Test

  def setup
    super
    # Le module à tester
    require './lib/required/app/analyse/parser'
  end


  def test_instance_de_parseur
    assert_silent { parser = FilmAnalyzor::Analyse::Parser.new('') }
  end

  def test_analyse_scenes
    apath     = analyse_path('pour_scenes')
    parser    = FilmAnalyzor::Analyse::Parser.new(apath)
    resultat  = nil
    # assert_silent { resultat  = parser.parse }
    resultat = parser.parse

    # ===> VÉRIFICATION <===
    # 
    assert resultat.key?(:scenes)
    assert(resultat[:scenes][1], "La première scène devrait exister.")
    expect = "Première scène"
    actual = resultat[:scenes][1][:pitch]
    assert_equal(expect, actual, "On devrait pouvoir obtenir le pitch d'une scène.")
  
  end

end
