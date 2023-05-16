# encoding: UTF-8
# frozen_string_literal: true
=begin
	Module pour construire le paradigme de field augmenté
=end
class PFA

	# 
	# {Boolean}
	# 
	# Retourne true si la construction du PFA est possible, c'est-à-dire
	# s'il possède les nœuds minimum requis.
	# 
	def construction_possible?
		missing_elements_for_build.empty?
	end

	# 
	# {Array of String}
	# 
	# Retourne la liste des noeuds requis pour la construction qui sont
	# manquants.
	# 
	# +as_human+	Si TRUE, on renvoie la liste sous forme humaine (pou
	# 						un message par exemple)
	# 
	def missing_elements_for_build(as_human = false)
		REQUIRE_NODES_FOR_BUILDING.collect do |etype|
			next if not noeud(etype).nil?
			as_human ? DATA_NOEUDS[etype][:long_name] : etype
		end.compact
	end

  #
  # Liste des nœuds minimum qu'il faut pour (commencer à) construire 
  # le PFA du film.
  # 
	REQUIRE_NODES_FOR_BUILDING = [:ex, :id, :p1, :dv, :d2, :p2, :dn, :cx, :pf]

end #/class PFA
