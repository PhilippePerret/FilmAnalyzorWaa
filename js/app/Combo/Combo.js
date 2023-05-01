'use strict';

class Combo {

  static prepareFirstCombo(){
    this.un = new Combo(1).prepare();
    this.deux = new Combo(2);
    this.deux.build().prepare()
  }


  constructor(id){
    this.id = id
  }

  /**
  * --- Observer Methods ---
  */

  onClickPlay(ev){
    if ( this.isPlaying ) {
      this.video.pause()
    } else {
      this.video.play()
    }
    this.isPlaying = !this.isPlaying
    this.btnPlay.innerHTML = this.isPlaying ? '⏹️' : '▶️'
    return stopEvent(ev)
  }
  onClickPause(ev){
    this.video.pause()
    this.isPlaying = false
    return stopEvent(ev)
  }

  prepare(){
    this.video.set()
    this.observe()
    return this // chainage
  }

  observe(){
    this.btnPlay = DGet('.btn-play', this.obj)
    this.btnPause = DGet('.btn-pause', this.obj)
    listen(this.btnPlay,'click', this.onClickPlay.bind(this))
    listen(this.btnPause,'click', this.onClickPause.bind(this))
  }

  build(){
    const node = Combo.un.obj.cloneNode(true)
    node.id = `combo-${this.id}`
    DGet('#combos').appendChild(node)
    return this // chainage
  }

  get video(){
    return this._video || ( this._video = new Video(this) )
  }
  get obj(){
    return this._obj || (this._obj = DGet(`#combo-${this.id}`))
  }
}
