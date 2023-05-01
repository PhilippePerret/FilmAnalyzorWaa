class Video {
  constructor(combo){
    this.combo = combo
  }

  play(){
    this.obj.play()
    // TODO On met en route une boucle qui affichera le temps
  }
  pause(){
    this.obj.pause()
  }

  /**
  * Préparation de la vidéo
  */
  set(){
    this.obj.setAttribute('width', VIDEO_WIDTH)
  }

  /* @return La balise vidéo HTML */
  get obj(){
    return this._obj || (this._obj = DGet('video', this.combo.obj))
  }
}
