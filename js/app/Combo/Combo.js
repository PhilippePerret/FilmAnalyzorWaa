'use strict';

class Combo {

  /**
  * Basculer d'une vidéo vers l'autre (raccourci ^ v)
  */
  static toggleCurrent(){
    if ( this.current.id == 1 ) {
      this.current = this.deux
    } else {
      this.current = this.un
    }
  }

  static prepareCombos(){
    this.un = new Combo(1).prepare();
    this.deux = new Combo(2);
    this.deux.build().prepare()
    this.current = this.un
  }

  static set current(v) {
    this._current && this._current.onBlur()
    this._current = v
    this._current.onFocus()
  }
  static get current(){return this._current}


  constructor(id){
    this.id = id
  }

  /**
  * --- Observer Methods ---
  */

  /**
  * Méthode appelée quand on focusse sur une vidéo.
  * 
  * @note
  *   Elle peut être appelée par la classe, par raccourci clavier
  */
  onFocus(){
    this.obj.classList.add('selected')
  }
  onBlur(){
    this.obj.classList.remove('selected') 
  }

  prepare(){
    this.observe()
    this.video.prepare()
    this.controller.prepare()
    this.textor.prepare()
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
