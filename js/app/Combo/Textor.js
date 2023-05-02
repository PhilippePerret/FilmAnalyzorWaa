'use strict';

class Textor {

  constructor(combo){
    this.combo = combo
  }

  prepare(){
    this.defineDomElements()
    this.observe()
  }

  get content(){
    return this.field.value
  }

  /*
  |  Volatile Data Methods
  */

  /**
  * @return [Integer] Le nom de 1000e de secondes correspondant au
  * temps courant, c'est-à-dire au temps où se trouve le curseur.
  * Ce temps est trouvé en remontant le texte jusqu'à trouver une marque
  * de temps (i.e. une ligne contenant une horloge)
  * Si aucun ligne n'est trouvée, c'est 0 qui est retourné.
  */
  get currentTime(){
    const lines  = this.itextarea.textFromStartToCursor().split("\n")
    var line, i = lines.length - 1 ;
    const regexp = new RegExp("^[0-9]:[0-9]{1,2}:[0-9]{1,2}(\.[0-9]{1,3})?$")
    for(; i > -1 ; --i ) {
      if ( regexp.exec(lines[i]) ) return h2s(lines[i])
    }
    return 0
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

  /**
    *****************************
    ***     Les SNIPPETS      ***
    *****************************
  */
  autocomplete(snip, ev){
    // console.warn("-> autocomplete", text, ev)
    switch(snip){
    case 't': /* - Mettre le temps au curseur - */
      this.remplaceSnippet(s2h(this.combo.controller.currentTime) + RET)
      break
    case 's': /* - Écrire SCENE au curseur - */
      this.remplaceSnippet('SCENE'+RET)
      break
    case 'sq': /* - Écrire SÉQUENCE au curseur - */
      this.remplaceSnippet('SEQUENCE'+RET, 2)
    }
  }
  remplaceSnippet(str, snippetLen = 1){
    const it = this.itextarea;
    it.select(it.selStart - snippetLen, it.selStart)
    it.replaceSelection(str, 'end')
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
    this.obj.style.height = px(this.combo.video.obj.offsetHeight)
  }

  observe(){
    listen(this.field,'focus',this.onFocus.bind(this))
    listen(this.field,'blur',this.onBlur.bind(this))
  }

  /*
  |  --- Dom Element Methods ---
  */

  defineDomElements(){
    this.itextarea = new Textarea(this.obj, {autocompleteMethod:this.autocomplete.bind(this)})
    this.field = this.obj
  }

  get obj(){return this._obj || (this._obj = DGet('textarea.textor', this.combo.obj))}
}
