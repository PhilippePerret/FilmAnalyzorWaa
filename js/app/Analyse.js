'use strict';
/**
* Class Analyse
* -------------
* Gestion de l'analyse courante
* 
*/

class Analyse {

  static get current(){
    return this._current || (this._current = new Analyse())
  }

  /**
  * Sauvegarde de l'analyse
  * -----------------------
  * Cela consiste à sauver son texte et ses données
  */
  save(){
    if ( ! this.data.path ) {
      return Finder.choose({wantedType:'folder'}).then(finderElement => {
        this.data.path = finderElement.path
        this.save()
      })
    }
    if ( ! this.data.titre ) {
      return demander("Titre du film", "", {
          buttonOk: {name:'Prendre ce titre', poursuivre: (reponse) => {this.data.titre = reponse; this.save.bind(this)}}
        , buttonCancel: {poursuivre: null}
      })
    }
    const waaData = {
      texte: this.texte, data: this.data
    }
    WAA.send({class:'FilmAnalyzor::Analyse', method:'save', data:waaData})
  }
  onSaved(retour){
    if ( retour.ok ) {
      this.isModified = false
      message("Analyse enregistrée.")
    } else {
      erreur(retour.msg)
    }
  }

  setZeroAbsolu(value){ 
    this.data.zero = value 
    this.save()
  }
  setTitreFilm(value){ this.data.titre = value; this.save() }

  get data(){
    return this._data || (this._data = {zero:null, titre:null, path: null})
  }
  get texte(){
    return Combo.un.textor.content
  }
}
