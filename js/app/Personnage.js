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

  }

  static onToggle(ev){
    if ( this.isDisplayed ) { this.hide() }
    else { this.show() }
    return stopEvent(ev)
  }
  static show(){ this.container.classList.remove('hidden'); this.isDisplayed = true }
  static hide(){ this.container.classList.add('hidden'); this.isDisplayed = false }

  /*
  |  Items Methods
  */

  /**
  * @return [Hash] La table à enregistrer dans les données de l'application
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
      dperso.dim && liste_persos.push(dperso)
    })
    return liste_persos
  }

  /**
  * À l'inverse de la précédente, cette méthode reçoit les données
  * personnages de l'analyse et les dispatche
  */
  static setData(data){
    if ( !data ) return ;
    var newId = 0
    data.forEach(dperso => {
      new Personnage(Object.assign(dperso,{id: ++newId})).buildEditingRow()
    })
    this.defineSnippetsTable()
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
    this.defineSnippetsTable()
    return stopEvent(ev)
  }
  /**
  * Méthode appelée pour ajouter un personnage
  */
  static onAdd(ev){
    console.warn("Je dois apprendre à créer un personnage.")
    return stopEvent(ev)
  }

  static get firstEditingRow(){return DGet('div#perso-1',this.listing)}


  /*
  |  Snippet Methods
  */

  static traiteSnippet(textor, snippet){
    if ( !this.snippetTable ) return
    this.snippetTable[snippet] && textor.remplaceSnippet(this.snippetTable[snippet] + ' ', snippet.length)
  }

  static defineSnippetsTable(){
    this.snippetTable = {}
    this.getData().forEach( dperso => {
      Object.assign(this.snippetTable, {[dperso.dim]: dperso.pseudo})
    })
  }

/* ------------------ INSTANCE ------------------------- */

constructor(data){
  console.info("data personnages = ", data)
  this.data = data
  this.id = this.data.id
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
  /*
  |  On met ses données à l'intérieur de la rangée
  */
  for ( var k in this.data ) {
    if ( k == 'id' ) continue ;
    DGet(`input.${k}`, row).value = this.data[k]
  }
}


}