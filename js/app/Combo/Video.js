'use strict';

class Video {

  static toggleCurrentVideo(){
    this._current && this.current.deselect()
    this.current = this.current.combo.id == 1 ? Combo.deux.video : Combo.un.video ;
    this.current.select()
  }

  static get current(){ return this._current || Combo.un.video }
  static set current(video) { 
    this._current = video 
    this.current.select()
  }

  /**
  * Pour appliquer les données des vidéos
  * (et notamment les options et le point courant)
  */
  static setData(data){
    if (!data) return
    for ( var combo_id in data ) {
      const combo = Combo.get(combo_id)
      combo && combo.video.setData(data[combo_id])
    }
  }
  /**
  * Pour récupérer les données vidéos
  * (options et position)
  */
  static getData(){
    var data = {}
    Combo.all.forEach(combo => {
      Object.assign(data, {[combo.id]: combo.video.getData()})
    })
    return data
  }

  constructor(combo){
    this.combo = combo
    this.observe()
  }

  show(){this.obj.classList.remove('hidden')}
  hide(){this.obj.classList.add('hidden')}
  
  select(){ this.obj.classList.add('selected')}
  deselect(){this.obj.classList.remove('selected')}

  /*
  |  --- Functional Methods ---
  */

  /**
  * Appelée pour charger la source +scr+
  */
  load(src){
    this.isReady = false
    this.source.src = 'http://localhost/FilmAnalyzor/' + src
    this.loadSpash.classList.remove('hidden')
    this.obj.load()
  }

  /*
  |  --- Observer Methods ---
  */

  /**
  * Cette méthode est appelée pour deux raisons :
  *   1. La source de la vidéo a changé (=> il faut la charger)
  *   2. On clique sur le barre de progression.
  */
  onLoaded(ev){
    if ( !this.isReady ) {    
      console.info("La vidéo #%s est prête.", this.combo.id)
      this.controller.onVideoLoaded()
      this.combo.textor.onVideoLoaded()
      this.loadSpash.classList.add('hidden')
      this.isReady = true
    } else {

    }
  }

  /*
  |  --- Functional Methods ---
  */

  /**
  * Préparation de la vidéo
  */
  prepare(){
    this.obj.setAttribute('width', this.combo.id == 1 ? VIDEO_WIDTH : VIDEO_WIDTH / 2)
    this.load('empty.mp4')
  }

  observe(){
    listen(this.obj,'canplaythrough',this.onLoaded.bind(this))
    listen(this.obj,'timeupdate', this.controller.onTimeUpdate.bind(this.controller))
    listen(this.obj,'click', this.controller.togglePlay.bind(this.controller))
  }

  /*
  |  --- Data Methods ---
  */
  // Récupération (pour enregistrement) des données courantes
  getData(){
    return {
        options: this.options.data
      , time:    this.currentTime
    }
  }
  // Application des données enregistrées
  setData(data){
    if (!data) return
    this.currentTime = data.time || 0
    this.options.set(data.options)
  }

  /*
  |  --- Volatile Data ---
  */

  get duration() { return this.obj.duration }
  get currentTime() { return this.obj.currentTime }
  set currentTime(v){ 
    this.obj.currentTime = v 
    if ( this.options.start_on_go && !this.controller.isPlaying) {
      this.controller.togglePlay()
    }
  }

  /**
  * Pour gérer les options de la vidéo (zéro, start_on_go, etc.)
  */
  get options(){
    return this._options || (this._options = new VideoOptions(this).prepare() )
  }

  /*
  |  --- Shortcuts ---
  */
  get controller(){return this.combo.controller}
  
  /*
  |  --- Fixed Data and Dom Elements ---
  */

  get loadSpash(){return DGet('div.load-splash', this.combo.obj)}

  get source(){
    return this._source || (this._source = DGet('source', this.obj))
  }
  /* @return La balise vidéo HTML */
  get obj(){
    return this._obj || (this._obj = DGet('video', this.combo.obj))
  }
}
