# encoding: UTF-8
# frozen_string_literal: true

# Données pour le dessins du PFA
# Les points sont pensés sur une distance totale de 120
class PFA

DATA_NOEUDS = {
  zr:  {id:'zr', long_name: 'Point Zéro (pour les temps exacts)', hname: 'Point Zéro', type: :system},
  # = EXPOSITION =
  ex:  {id:'ex',  long_name: 'Exposition', hname: 'EXPOSITION', dim:'EXPO', start:0, end: 30, type: :part, inner: [:pre, :ip, :id, :rf, :p1]},
  pre: {id:'pre', long_name: 'Prélude', hname: 'Prélude', mark:'PR', start:0,        end:12, type: :seq, no_horloge:true},
  ip:  {id:'ip',  long_name: 'Incident Perturbateur', hname: 'I.P.',        start:12,       end:(12+2), type: :noeud},
  id:  {id:'id',  long_name: 'Incident Déclencheur', hname: 'I.D.',        start:20 ,      end:(20+2), type: :noeud},
  rf:  {id:'rf',  long_name: 'Début du refus de l’appel', hname: 'Refus', mark:'RF', start:(30 - 7), end:(30 - 2), type: :seq},
  p1:  {id:'p1',  long_name: 'Premier Pivot', hname: 'Pvt1', mark:'P1', start:(30 - 2), end:30, type: :noeud},
  # = DÉVELOPPEMENT =
  dv:  {id:'dv',  long_name: 'Développement, partie 1', hname: 'DEVELOPPEMENT (PART I)', dim:'DEV.P1', start:30, end:60, type: :part, inner: [:t1, :cv]},
  t1:  {id:'t1',  long_name: 'Premier tiers', hname: '1/3',         start:(40 - 2), end:(40 + 2), type: :noeud},
  cv:  {id:'cv',  long_name: 'Clé de voûte', hname: 'CdV', mark:'CV', start:(60 - 2), end:(60 + 2), type: :noeud},
  d2:  {id:'d2',  long_name: 'Développement, partie 2', hname: 'DEVELOPPEMENT (PART II)', dim:'DEV.P2', start:60, end:90, type: :part, inner:[:t2,:cr,:p2]},
  t2:  {id:'t2',  long_name: 'Second tiers', hname: '2/3',         start:(80 - 2), end:(80 + 2), type: :noeud},
  cr:  {id:'cr',  long_name: 'Crise', hname:'Crise', mark:'CR', start:(90 - 6), end:(90 - 2), type: :noeud},
  p2:  {id:'p2',  long_name: 'Second Pivot', hname:'Pvt2', mark:'P2', start:(90 - 2), end:90, type: :noeud},
  # = DÉNOUEMENT =
  dn:  {id:'dn',  long_name: 'Dénouement', hname: 'DENOUEMENT', dim:'DEN.', start:90, end: 120, type: :part, inner:[:cx, :de]},
  cx:  {id:'cx',  long_name: 'Climax', hname:'Climax', mark:'CX', start:(120 - 12), end:(120 - 2), type: :noeud},
  de:  {id:'de',  long_name: 'Désinence', hname:'Dés.', mark:'DS', start:(120 - 2),  end:120, type: :seq},
  pf:  {id:'pf',  long_name: 'Point Final (début noir-générique)', hname:'Point Final', type: :system}
}

# Pour passer tout en secondes :
# DATA_NOEUDS.each do |kn, dn|
#   next if dn[:start].nil?
#   dn.merge!(start: dn[:start] * 60, end: dn[:end] * 60)
# end

end #/class PFA
