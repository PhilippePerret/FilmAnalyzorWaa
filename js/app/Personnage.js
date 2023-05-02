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
    data.forEach(dperso => new Personnage(dperso).buildEditingRow())
  }

  /*
  |  --- Observer Methods ---
  */

  /**
  * Méthode appelée pour ajouter un personnage
  */
  static onAdd(ev){
    console.warn("Je dois apprendre à créer un personnage.")
    return stopEvent(ev)
  }

  static firstEditingRow(){return DGet('div#perso-1',this.listing)}

/* ------------------ INSTANCE ------------------------- */

constructor(data){
  this.data = data
}

/**
* Pour construire sa rangée d'édition
*/
buildEditingRow(){
  const row = Personnage.firstEditingRow.cloneNode(true)
  row.id = `perso-${this.data.id}`
  Personnage.listing.appendChild(row)
}


}
