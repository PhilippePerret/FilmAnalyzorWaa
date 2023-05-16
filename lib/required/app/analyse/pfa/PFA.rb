# encoding: UTF-8
# frozen_string_literal: true
=begin
	Class PFA
	----------
	Pour la gestion des paradigmes de Field
=end
require_relative 'lib/constants'
require_relative 'lib/utils'
require_relative 'lib/extensions/Number'
require_relative 'lib/PFANoeudAbs'
require_relative 'lib/PFANoeudRel'
require_relative 'lib/Horloge'
require_relative 'lib/builder'
require_relative 'lib/PFA_helpers'

class PFA

# -------------------------------------------------------------------
#
#		INSTANCE
#
# -------------------------------------------------------------------

#
# @prop [Hash] Les données du Paradigme de Field Augmenté
attr_reader :data

# @param [Hash] data Données du Paradadigme de Field Augmenté
# (cf. ci-dessus)
def initialize(data)
	@data = data	
end

# -------------------------------------------------------------------
#
#		MÉTHODES FONCTIONNELLE
#
# -------------------------------------------------------------------

def save
  puts "Je dois sauver le PFA dans #{path.inspect}".jaune
	# File.open(path,'wb'){|f|f.write(YAML.dump(data))}	
end

# -------------------------------------------------------------------
#
#		MÉTHODES DE DONNÉES
#
# -------------------------------------------------------------------

def noeud(etype)
	noeuds[etype]
end

# -------------------------------------------------------------------
#
#		DATA
#
# -------------------------------------------------------------------

def index				;@index||=data[:index]end
def name				;@name||=data[:name]end
def description	;@description||=data[:description]end
def noeuds			;@noeuds||=data[:noeuds]||{}end
def folder      ;@folder||=data[:folder] end


# @prop Dossier dans lequel seront construites les images
def export_folder
  @export_folder ||= mkdir(File.join(folder,'export'))
end

def path
	@path ||= File.join(folder,"pfa#{index}.yaml")
end

end #/class PFA
