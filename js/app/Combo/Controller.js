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
  |  --- Action Methods ---
  */

  /**
  * Pour aller au temps défini par +secs+
  */
  goTo(secs){
    this.currentTime = secs
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
      this.controller.pause()
    } else {
      this.controller.play()
    }
    this.isPlaying = !this.isPlaying

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

  onChooseOption(ev){
    switch(this.menuOptions.value){
    case 'zero-absolu':
      console.warn("Je dois apprendre à régler le zéro absolu")
      break;
    default:
      console.warn("Option inconnue : ", this.menuOptions.value)
    }
    this.menuOptions.selectedIndex = 0
  }

  observe(){
    listen(this.btnPlay,'click', this.onClickPlay.bind(this))
    listen(this.btnStop,'click', this.onClickStop.bind(this))
    listen(this.progress,'click', this.onClickProgress.bind(this))
    listen(this.menuOptions,'change', this.onChooseOption.bind(this))
  }

  defineDomElements(){
    this.btnPlay      = DGet('.btn-play', this.combo.obj)
    this.btnStop      = DGet('.btn-stop', this.combo.obj)
    this.menuOptions  = DGet('select.menu-options', this.combo.obj)
  }

  get progress(){return this._progress || (this._progress = DGet('progress',this.combo.obj))}
  get horloge(){return this._horloge || (this._horloge = DGet('.horloge',this.combo.obj))}
  get video(){return this._video || (this._video = this.combo.video.obj)}
}
