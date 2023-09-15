'use strict';
/**
* Class Personnage
* ----------------
* Gestion des personnages du film
*/

class Personnage {

  static get container(){return DGet('div#container-personnages')}
  static get listing(){return DGet('div#personnages', this.container)}

  static prepare(){
    this.observe()
  }

  static observe(){
    this.btnAdd = DGet('button.btn-add', this.container)
    listen(this.btnAdd,'click', this.onAdd.bind(this))
    this.btnSet = DGet('button.btn-set', this.container)
    listen(this.btnSet,'click',this.onSet.bind(this))
    this.btnToggle = DGet('footer#main button.btn-persos')
    listen(this.btnToggle, 'click', this.onToggle.bind(this))
    this.btnClose = DGet('button.btn-close',this.container)
    listen(this.btnClose,'click',this.hide.bind(this))
  }

  static toggle(){
    if ( this.isDisplayed ) { this.hide() }
    else { this.show() }
  }

  static onToggle(ev){
    this.toggle()
    return stopEvent(ev)
  }
  static show(){ this.container.classList.remove('hidden'); this.isDisplayed = true }
  static hide(){ this.container.classList.add('hidden'); this.isDisplayed = false }

  /*
  |  Items Methods
  */

  /**
  * @return [Hash] La table à enregistrer dans les données de l'application
  * 
  * @note
  *   On ne prend que les lignes qui définissent au moins un dim et
  *   un pseudo
  */
  static getData(){
    const liste_persos = []
    this.listing.querySelectorAll('div.personnage').forEach( div => {
      const dperso = {
          dim: DGet('input.dim', div).value
        , pseudo: DGet('input.pseudo', div).value
        , patronyme: DGet('input.patronyme', div).value
        , description: DGet('input.description', div).value
      }
      dperso.dim && dperso.pseudo && liste_persos.push(dperso)
    })
    return liste_persos
  }

  /**
  * À l'inverse de la précédente, cette méthode reçoit les données
  * personnages de l'analyse et les dispatche
  * 
  */
  static setData(data){
    if ( data ) {    
      data.forEach(dperso => {
        new Personnage(Object.assign(dperso,{id:this.getNewId()})).buildEditingRow()
      })
    }
    this.update()
  }

  static getNewId(){
    this.lastId || ( this.lastId = 0 )
    return ++ this.lastId
  }

  /*
  |  --- Observer Methods ---
  */

  /**
  * Méthode appelée quand on clique sur le bouton "Définir"
  * Ça ferme la boite et ça définit les snippets
  */
  static onSet(ev){
    this.hide()
    this.update()
    return stopEvent(ev)
  }
  /**
  * Méthode appelée pour ajouter un personnage
  */
  static onAdd(ev){
    new Personnage({id:this.getNewId()}).buildEditingRow()
    return stopEvent(ev)
  }

  static get firstEditingRow(){return DGet('div#perso-1',this.listing)}

  static update(){
    this.items = this.getData()
    this.count = this.items.length
    this.defineSnippetsTable(this.items)
  }

  /*
  |  Snippet Methods
  */

  static traiteSnippet(snippet){
    if ( !this.snippetTable ) return
    const nom = this.snippetTable[snippet.snip]
    nom && snippet.remplaceSnippet(nom + ' ', snippet.snip.length)
  }

  static defineSnippetsTable(personnages){
    this.snippetTable = {}
    personnages.forEach( dperso => {
      Object.assign(this.snippetTable, {[dperso.dim]: dperso.pseudo})
    })
  }

/* ------------------ INSTANCE ------------------------- */

constructor(data){
  this.data = data
  this.id = this.data.id
}

/**
* Méthode appelée pour supprimer le personnage
*/
onSup(ev){
  if ( this.id > 1 || Personnage.count > 1) this.row.remove()
  else {
    /* On vide seulement les champs */
    this.reset()
  }
  Personnage.update() // pour actualiser les snippets, notamment
  return stopEvent(ev)
}

reset(){
  this.row.querySelectorAll('input[type="text"]').forEach( i => i.value = "")
}

/**
* Pour construire sa rangée d'édition
*/
buildEditingRow(){
  let row ;
  if ( this.id == 1 ) {
    row = DGet('div#perso-1.personnage')
  } else {
    row = Personnage.firstEditingRow.cloneNode(true)
    row.id = `perso-${this.id}`
    Personnage.listing.appendChild(row)
  }
  if (!row){
    console.error("Impossible d'obtenir la rangée personnage de #%s",this.id)
    return
  }
  this.row = row
  /*
  |  On observe la rangée
  */
  this.observe()
  /*
  |  On met ses données à l'intérieur de la rangée
  |  Mais à la création, data ne contient que :id. Donc pour
  |  s'assurer que les champs soient bien vidés, on utilise reset()
  |  même si ça fait doublon.
  */
  this.reset()
  for ( var k in this.data ) {
    if ( k == 'id' ) continue ;
    DGet(`input.${k}`, row).value = this.data[k] || ''
  }
}

observe(){
  listen(DGet('button.btn-sup', this.row), 'click', this.onSup.bind(this))
}

}
