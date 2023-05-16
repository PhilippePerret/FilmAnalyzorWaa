class PFA

  #
  # Liste des nœuds minimum qu'il faut pour (commencer à) construire 
  # le PFA du film.
  # 
  REQUIRE_NODES_FOR_BUILDING = [:ex, :id, :p1, :dv, :d2, :p2, :dn, :cx, :pf]

  # 
  # - Dimensions -
  # 

  PFA_WIDTH   = 4000 # 4000px (en 300dpi)
  PFA_HEIGHT  = PFA_WIDTH / 4
  # PFA_HEIGHT  = (PFA_WIDTH.to_f / 1.6).to_i
  PFA_LEFT_MARGIN   = 150
  PFA_RIGHT_MARGIN  = 150
  LINE_HEIGHT = (PFA_HEIGHT.to_f / 15).to_i

  # ImageMagick
  CONVERT_CMD = 'convert' # avant : /usr/local/bin/convert


# Données pour le dessins du PFA
# Les points sont pensés sur une distance totale de 120

class PFANoeudAbs

  TOPS        = { part: PFA::LINE_HEIGHT,      seq:3*PFA::LINE_HEIGHT,       noeud:3*PFA::LINE_HEIGHT  }
  HEIGHTS     = { part: PFA_HEIGHT/1.4,       seq: 50,        noeud: 50   }
  # HEIGHTS[:part] définit la hauteur des marques de partie "EXPOSITION", etc.
  FONTSIZES   = { part: 10,       seq: 8,         noeud: 7  }
  FONTWEIGHTS = { part:3,         seq:2,          noeud:1     }
  COLORS      = { part:'gray75',  seq:'gray55',   noeud:'gray55' }
  DARKERS     = { part:'gray50',  seq:'gray45',   noeud:'gray45' }
  GRAVITIES   = { part:'Center',  seq:'Center',   noeud:'Center'}
  BORDERS     = { part:3,         seq:2,          noeud:1}

end #/class PFANoeudAbs

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


end #/class PFA
