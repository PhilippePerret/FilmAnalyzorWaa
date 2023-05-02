'use strict';

class Video {
  constructor(combo){
    this.combo = combo
    this.observe()
  }

  show(){this.obj.classList.remove('hidden')}
  hide(){this.obj.classList.add('hidden')}

  /*
  |  --- Functional Methods ---
  */

  /**
  * Appelée pour charger la source +scr+
  */
  load(src){
    this.isReady = false
    this.source.src = src
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
    console.log("-> Video#prepare", this.combo.id)
    this.obj.setAttribute('width', VIDEO_WIDTH)
    this.load('http://localhost/FilmAnalyzor/movie.mp4')
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

  get source(){
    return this._source || (this._source = DGet('source', this.obj))
  }
  /* @return La balise vidéo HTML */
  get obj(){
    return this._obj || (this._obj = DGet('video', this.combo.obj))
  }
}
