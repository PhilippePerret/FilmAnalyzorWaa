'use strict';

class Video {

  static toggleCurrentVideo(){
    this._current && this.current.deselect()
    this.current = this.current.combo.id == 1 ? Combo.deux.video : Combo.un.video ;
    this.current.select()
  }

  static get current(){ return this._current || Combo.un.video }
  static set current(video) { this._current = video }

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
      this.combo.controller.onVideoLoaded()
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
    console.log("-> Video#observer", this.combo.id)
    listen(this.obj,'canplaythrough',this.onLoaded.bind(this))
    listen(this.obj,'timeupdate', this.combo.controller.onTimeUpdate.bind(this.combo.controller))
    listen(this.obj,'click', this.combo.controller.togglePlay.bind(this.combo.controller))
  }

  /*
  |  --- Volatile Data ---
  */

  get duration() { return this.obj.duration }
  get currentTime() { return this.obj.currentTime }
  set currentTime(v){ this.obj.currentTime = v }

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
