'use strict';

class Controller {
  constructor(combo){
    this.combo = combo;
  }

  prepare(){
    this.defineDomElements()
    this.observe()
  }

  /*
  |  --- Action/functional Methods ---
  */

  /**
  * Pour aller au temps défini par +secs+
  */
  goTo(secs){
    this.currentTime = secs
  }

  /**
  * Pour rejoindre soit le temps sous le curseur dans le champ de
  * texte, soit le marqueur courant s'il est défini. Si aucune des
  * deux informations n'est donnée, on indique ce qu'il faut faire.
  */
  goToTextTimeOrCurrentMarker(){
    const lineCurTime = Combo.current.textor.lineCurrentTime
    if ( lineCurTime ) {
      /*
      |  Temps défini sur la ligne du curseur
      */
      this.goTo(lineCurTime)
    } else if ( this.currentMarker ) {
      /*
      |  Temps défini par un marqueur
      */
      this.goTo(this.currentMarker)
    } else {
      /*
      |  Rien n'est défini
      */
      message(MESSAGES.helpForGoTo)
    }
  }

  /**
  * Pour définir le marker courant (avec CMD-m) au temps
  * courant
  */
  defineMarker(){
    this.currentMarker = this.video.currentTime
    message(MESSAGES.confirmMarker, [s2h(this.currentMarker)])
  }

  /**
  * Pour remonter le temps
  */
  moveBackward(shift, alt) {
    var cran ;
    if ( shift ) cran = 1
    else if ( alt ) cran = 10
    else cran = 5 / 100
    this.currentTime = this.currentTime - cran
  }
  moveForward(shift, alt) {
    var cran ;
    if ( shift ) cran = 1
    else if ( alt ) cran = 10
    else cran = 5 / 100
    this.currentTime = this.currentTime + cran
  }

  togglePlay(){
    if ( this.isPlaying ) {
      this.pause()
    } else {
      this.play()
    }
    this.isPlaying = !this.isPlaying
    this.setButtons()
  }

  play(){
    this.video.play()
  }
  pause(){
    this.video.pause()
  }
  stop(){
    this.pause()
    this.video.currentTime = 0
    this.setButtons()
  }

  /*
  |  --- Display Methods ---
  */

  setButtons(){
    this.btnPlay.innerHTML = this.isPlaying ? '⏸️' : '▶️'
  }

  get currentTime() { return this.video.currentTime }
  set currentTime(v){ this.video.currentTime = v }

  /*
  |  --- Observer Methods ---
  */

  onClickPlay(ev){
    this.togglePlay()
    return stopEvent(ev)
  }

  /**
  * Méthode appelée quand le temps change
  */
  onTimeUpdate(ev){
    this.progress.value = this.currentTime;
    this.horloge.innerHTML = s2h(this.video.currentTime)
  }

  onClickStop(ev){
    this.stop()
    this.isPlaying = false
    return stopEvent(ev)
  }

  /**
  * Méthode appelée quand une vidéo est chargée
  */
  onVideoLoaded(){
    this.duration = this.video.duration
    this.progress.setAttribute('max', this.duration)
  }

  /**
  * Appelée quand on clique sur la barre de progression (pour rejoindre
  * une partie du film)
  */
  onClickProgress(ev){
    const rect = this.progress.getBoundingClientRect();
    const pos  = (ev.pageX - rect.left) / this.progress.offsetWidth;
    this.currentTime = pos * this.duration;
    this.progress.value = this.currentTime
    return stopEvent(ev)
  }

  observe(){
    listen(this.btnPlay,'click', this.onClickPlay.bind(this))
    listen(this.btnStop,'click', this.onClickStop.bind(this))
    listen(this.progress,'click', this.onClickProgress.bind(this))
  }

  defineDomElements(){
    this.btnPlay      = DGet('.btn-play', this.combo.obj)
    this.btnStop      = DGet('.btn-stop', this.combo.obj)
  }

  get progress(){return this._progress || (this._progress = DGet('progress',this.combo.obj))}
  get horloge(){return this._horloge || (this._horloge = DGet('.horloge',this.combo.obj))}
  get video(){return this._video || (this._video = this.combo.video.obj)}
  get ivideo(){return this._ivideo || (this._ivideo = this.combo.video)}
}
