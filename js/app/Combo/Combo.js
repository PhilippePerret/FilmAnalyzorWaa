'use strict';

class Combo {

  static prepareCombos(){
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


  prepare(){
    this.observe()
    this.video.prepare()
    this.controller.prepare()
    return this // chainage
  }

  observe(){
  }

  build(){
    const node = Combo.un.obj.cloneNode(true)
    node.id = `combo-${this.id}`
    DGet('#combos').appendChild(node)
    return this // chainage
  }

  get textor      (){ return this._textor || (this._textor = new Textor(this))}
  get controller  (){return this._controller || (this._controller = new Controller(this))}
  get video       (){return this._video || ( this._video = new Video(this) )}
  get obj         (){return this._obj || (this._obj = DGet(`#combo-${this.id}`))}
}
