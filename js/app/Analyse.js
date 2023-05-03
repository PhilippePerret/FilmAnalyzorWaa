'use strict';
/**
* Class Analyse
* -------------
* Gestion de l'analyse courante
* 
*/

class Analyse {

  static get current(){
    return this._current || (this._current )
  }
  static set current(analyse){ this._current = analyse }

  static saveCurrent(){
    this.current.save()
  }

  /**
  * Préparation de l'analyse
  */
  static prepare(){
    Combo.prepareCombos()
    Personnage.prepare()
    this.observe()
    /*
    |  Ouverture
    |  Pour la forcer, on renseigne les données
    */
    // const data = undefined
    const data = {type:'folder', path:'/Users/philippeperret/Library/Mobile Documents/com~apple~CloudDocs/ECRITURE/Analyses/TheStraightStory'}
    this.open(data)
  }

  static observe(){
    this.saveBtn = DGet('footer#main button.btn-save')
    this.openBtn = DGet('footer#main button.btn-open')
    this.manuelBtn = DGet('footer#main button.btn-manuel')
    listen(this.saveBtn, 'click', this.saveCurrent.bind(this))
    listen(this.openBtn, 'click', this.open.bind(this))
    listen(this.manuelBtn, 'click', QuickHelp.toggle.bind(QuickHelp))
  }

  /**
  * Pour ouvrir une analyse
  */
  static open(path){
    if ( path && path.type && path.type == 'folder' ) {
      WAA.send({class:'FilmAnalyzor::Analyse',method:'load',data:{path:path.path}})
    } else {
      Finder.choose({wantedType:'folder'}).then(this.open.bind(this)).catch(err=>{console.log("Renoncement")})
    }
  }
  /* Méthode appelée par le serveur au retour de la précédente */
  static onLoad(retour){
    this.current = new Analyse(retour)
  }


  constructor(data){
    this.data   = data && data.data // ça dispatche les données
    this.texte  = data && data.texte
  }

  /*
  |  Display Methods
  */

  setTitre(){
    DGet('header span#titre-film').innerHTML = this.data.titre
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
    if ( ! this.data.video ) {
      return demander("Nom de la vidéo (nom seul)", "", {
          buttonOk: {name:'Nom complet du fichier', poursuivre: (reponse) => {this.data.video = reponse; this.save.bind(this)}}
        , buttonCancel: {poursuivre: null}
      })
    }
    /* - Actualisation des données personnages - */
    this.data.personnages = Personnage.getData()

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

  /*
  |  --- Definition Methods ---
  */
  setZeroAbsolu(value){ 
    this.data.zero = value 
    this.save()
  }
  setTitreFilm(value){ this.data.titre = value; this.save() }


  /*
  |  --- Functional Methods ---
  */

  /*
  |  --- Data Methods ---
  */

  get data(){ return this._data || (this._data = {zero:null, titre:null, path: null, video: null, personnages:null}) }
  set data(v) { 
    this._data = v 
    /*
    |  On en profite pour dispatcher les informations
    */
    Combo.un.controller.showZeroAbsolu(this.data.zero)
    this.setTitre()
    Combo.un.video.load(this.data.video)
    Combo.deux.video.load(this.data.video) // pour le moment, on met toujours la même vidéo
    /* Les personnages */
    Personnage.setData(this.data.personnages)
  }

  get texte( )  { return Combo.un.textor.content }
  set texte(str){ Combo.un.textor.content = str }
}
