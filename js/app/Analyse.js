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
    |  Ouverture de l'analyse
    |  ----------------------
    |  Soit la dernière, soit celle dans laquelle on a lancé
    |  l'application
    */
    this.openCurrent()
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
  * Pour ouvrir l'analyse courante
  */
  static openCurrent(){
    WAA.send({class:'FilmAnalyzor::Analyse',method:'load_current'})
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
  **************************************** 
  *** Sauvegarde complète de l'analyse ***
  * --------------------------------
  * Cela consiste à sauver son texte et ses données. On procède par
  * paquet, pour ne pas être embêté par un texte infernalement long.
  **************************************** 
  */
  save(){
    if ( this.isSaving ) return
    this.isSaving = true
    this.checkData()
      .then(this.saveData.bind(this))
      .then(this.saveTexte.bind(this))
      .then(this.onEndSaving.bind(this))
      .catch(err => {
        console.warn("Annulation de l'enregistrement : ", err)
      })
  }
  onEndSaving(){
    console.info("-> onEndSaving")
    this.isModified = false
    this.isSaving = false
  }

  /**
   * @async
  * Méthode, appelée à l'enregistrement, qui vérifie que toutes les
  * données sont fournies et conformes.
  */
  checkData(){
    console.info("-> checkData")
    return new Promise((ok,ko) => {
      /*
      |  Le path de l'analyse doit être défini
      */
      if ( ! this.data.path ) {
        return Finder.choose({wantedType:'folder'}).then(finderElement => {
          if ( finderElement ) {
            this.data.path = finderElement.path
            this.checkData.call(this)
          } else { ko('Renoncement') }
        })
      }
      /*
      |  Le titre du film doit être défini
      */
      if ( ! this.data.titre ) {
        return demander("Titre du film", "", {
            buttonOk: {name:'Prendre ce titre', poursuivre: (reponse) => {
              this.data.titre = reponse
              this.checkData.call(this)}
            }
          , buttonCancel: {poursuivre:ko}
        })
      }
      /*
      |  Le nom du fichier vidéo doit être défini
      */
      if ( ! this.data.video ) {
        return demander("Nom de la vidéo (nom seul)", "", {
            buttonOk: {name:'Nom complet du fichier', poursuivre: (reponse) => {
              this.data.video = reponse
              this.checkData.call(this)}
            }
          , buttonCancel: {poursuivre:ko}
        })
      }
      /* 
      | - Actualisation des données personnages - 
      */
      this.data.personnages = Personnage.getData()
      /* 
      | - Actualisation des données vidéo - 
      */
      this.data.videos = Video.getData()
      /*
      |  On peut poursuivre
      */
      ok()
    })
  }
  /**
  * @sync
  * 
  * Après que les données ont été checkées (checkData) on peut les
  * enregistrer.
  */
  saveData(retour){
    console.info("-> saveData / retour = ", retour)
    if ( undefined == retour ) {
      /*
      |  On procède à la sauvegarde
      */
      return new Promise((ok,ko)=> {
        this.saveData.onOk = ok
        this.saveData.onKo = ko
        const waaData = { data: this.data }
        WAA.send({class:'FilmAnalyzor::Analyse', method:'save_data', data:waaData})
      })
    } else {
      /*
      |  retour de la sauvegarde
      */
      if ( retour.ok ) {
        this.saveData.onOk.call(this)
      } else {
        this.saveData.onKo.call(this, retour.msg)
      }
    }
  }

  /**
  * @sync
  * 
  * Sauvegarde du texte
  */
  saveTexte(retour){
    console.info("-> saveTexte / retour = ", retour)
    /*
    |  Quand il y a du texte
    */
    if ( undefined === retour) {
      /*
      |  Quand il n'y a pas encore de texte
      */
      if ( this.texte.length == 0 ) { return new Promise((ok,ko) => { ok() }) }
      /*
      |  Début de la sauvegarde
      */
      return new Promise((ok,ko) => {
        this.saveTexte.onOk = ok
        this.saveTexte.onKo = ko
        this.prepareTexteForSaving()
        const waaData = { first_portion: this.texteStack.shift(), path: this.data.path }
        WAA.send({class:'FilmAnalyzor::Analyse', method:'save_texte', data:waaData})
      })
    } else if ( this.texteStack.length ) {
      /*
      |  Il y a encore des paquets à enregistrer
      */
      const waaData = { portion_texte: this.texteStack.shift(), path: this.data.path }
      WAA.send({class:'FilmAnalyzor::Analyse', method:'save_texte', data:waaData})
    } else {
      /*
      |  Tous les textes ont été enregistrés (ou pas…)
      */
      if ( retour.ok ) {
        this.saveTexte.onOk.call(this)
      } else {
        this.saveTexte.onKo.call(this, retour.msg)
      }
    }
  }

  /**
  * Préparation du texte pour la sauvegarde
  * 
  * On le découpe en portion de TEXTE_SECTION_LENGTH caractères
  * Cela produit texteStack, la pile avec les textes
  */
  prepareTexteForSaving(){
    var str = this.texte
    this.texteStack = []
    while ( str.length > TEXTE_SECTION_LENGTH + 100 ) {
      this.texteStack.push(str.substring(0, TEXTE_SECTION_LENGTH))
      str = str.substring(TEXTE_SECTION_LENGTH, str.length)
    }
    if ( str.length ) {
      this.texteStack.push(str)
    }
  }

  get isModified(){ return this._ismodified }
  set isModified(v) {
    console.log("-> ismodified")
    this._ismodified = v
    Analyse.saveBtn.classList[v ? 'add' : 'remove']('warn')
  }

  /*
  |  --- Definition Methods ---
  */
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
    this.setTitre()
    Combo.un.video.load(this.data.video)
    Combo.deux.video.load(this.data.video) // pour le moment, on met toujours la même vidéo
    /* Les personnages */
    Personnage.setData(this.data.personnages)
    /* Les options des vidéos */
    Video.setData(this.data.videos)
  }

  get texte( )  { return Combo.un.textor.content }
  set texte(str){ Combo.un.textor.content = str }
}
