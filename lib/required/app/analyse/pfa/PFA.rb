# encoding: UTF-8
# frozen_string_literal: true
=begin
	Class PFA
	----------
	Pour la gestion des paradigmes de Field
=end
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

def path
	@path ||= File.join(film.pfa_folder,"pfa#{index}.yaml")
end
end #/class PFA
