'use strict';

class Textor {

  constructor(combo){
    this.combo = combo
  }

  onVideoLoaded(){
    console.warn("Je dois régler la hauteur du texteur")
    console.log("this.combo.video.obj.innerHeight = ", this.combo.video.obj.offsetHeight)
    this.obj.style.height = px(this.combo.video.obj.offsetHeight)
  }


  get obj(){return this._obj || (this._obj = DGet('textarea.textor', this.combo.obj))}
}
