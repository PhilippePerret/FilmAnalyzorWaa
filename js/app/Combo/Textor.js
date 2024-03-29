'use strict';

class Textor {

  constructor(combo){
    this.combo = combo
  }

  prepare(){
    this.defineDomElements()
    this.observe()
  }

  /* - Contenu de l'analyse - */
  get content ( ){ return this.field.value}
  set content (v){ this.field.value = v }

  /*
  |  Volatile Data Methods
  */

  /**
  * @return [Integer] Le nombre de 1000e de secondes correspondant au
  * temps courant, c'est-à-dire au temps où se trouve le curseur.
  * Ce temps est trouvé en remontant le texte jusqu'à trouver une marque
  * de temps (i.e. une ligne contenant une horloge)
  * Si aucun ligne n'est trouvée, c'est 0 qui est retourné.
  * 
  * @note
  *   Si on ne doit regarder que sur la ligne courante (sans remonter
  *   pour prendre un temps), alors il faut utiliser la méthode 
  *   suivante (lineCurrentTime)
  */
  get currentTime(){
    const lines  = this.itextarea.textFromStartToCursor().split("\n")
    var line, i = lines.length - 1 ;
    for(; i > -1 ; --i ) {
      if ( REG_TIME_MARK.exec(lines[i]) ) return h2s(lines[i])
    }
    return 0
  }
  /**
  * @return Le nombre de millième de secondes [Integer] du temps écrit
  * sur la ligne courante, ou NULL si le curseur ne se trouve pas sur
  * une ligne définissant un temps.
  */
  get lineCurrentTime(){
    const lines = this.itextarea.textFromStartToCursor().split("\n")
    var i = lines.length - 1 ;
    return REG_TIME_MARK.exec(lines[i]) ? h2s(lines[i]) : null
  }

  /*
  |  --- Observer Methods ---
  */

  onKeyUp(ev){
    // console.log("ev = ", ev)
    if ( ! KeyboardEventManager.onUpCommon(ev) ) { return false  }
  }
  onKeyDown(ev){

    if ( ! KeyboardEventManager.onDownCommon(ev) ) { return false }
    if ( ev.key == 'Tab' ) {
      /*
      |  On bloque la touche tabulation et il faudra même voir si 
      |  ça n'est pas un snippet
      */
      // console.warn("Je dois apprendre à traiter '%s'", this.textarea.wordBeforeCursor)
      // return stopEvent(ev)
    }
  }

  onFocus(ev){
    this.curOnkeyup   = window.onkeyup
    this.curOnkeydown = window.onkeydown
    window.onkeyup    = this.onKeyUp.bind(this)
    window.onkeydown  = this.onKeyDown.bind(this)
    Combo.current = this.combo
    return stopEvent(ev)
  }
  onBlur(ev){
    window.onkeyup    = this.curOnkeyup
    window.onkeydown  = this.curOnkeydown
    return stopEvent(ev)
  }
  onVideoLoaded(){
    this.obj.style.height = px(this.combo.video.obj.offsetHeight - 26)
  }

  observe(){
    listen(this.field,'focus',this.onFocus.bind(this))
    listen(this.field,'blur',this.onBlur.bind(this))
  }

  /*
  |  --- Dom Element Methods ---
  */

  defineDomElements(){
    this.itextarea = new Textarea(this.obj, {autocompleteMethod:Snippet.exec.bind(Snippet, this)})
    this.field = this.obj
  }

  get obj(){return this._obj || (this._obj = DGet('textarea.textor', this.combo.obj))}
}
