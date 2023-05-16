require 'pretty_inspect'
require "minitest/autorun"
require 'minitest/reporters'
require 'yaml'

require 'clir'
# require 'clirtest'
require 'osascript'
require 'osatest'



# Pour charger plus facilement les modules de l'application
# $LOAD_PATH.unshift File.dirname(__dir__)


TEST_FOLDER = __dir__.freeze
ASSETS_FOLDER = File.join(TEST_FOLDER,'assets')

reporter_options = { 
  color: true,          # pour utiliser les couleurs
  slow_threshold: true, # pour signaler les tests trop longs
}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]


module Minitest
  class Test

    def analyse_path(fname)
      fname = "#{fname}.ana.txt" unless fname.end_with?('.ana.txt')
      File.join(asset_analyses_folder, fname)
    end
    def asset_analyses_folder
      @asset_analyses_folder ||= File.join(ASSETS_FOLDER,'analyses')
    end



    def new_tosa
      return OSATest.new({
        app:'Terminal',
        delay: 0.5,
        window_bounds: [0,0,1200,800]
      })
    end
  end #/class Test
end #/module Minitest
