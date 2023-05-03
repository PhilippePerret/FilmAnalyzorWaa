'use strict';
/**
* Gestion des évènements
*/


class KeyboardEventManager {
  static onPress(ev){
    return true
  }
  /**
  * @return true si la touche n'a pas été traitée
  */
  static onDownCommon(ev){
    if ( ev.ctrlKey ) {
      // console.warn("[DOWN] Je dois apprendre à jouer le raccourci control + ", ev.key)
      // return stopEvent(ev)
    } 
    if ( ev.metaKey ) {
      const combo = Video.current.combo
      const control = combo.controller
      switch(ev.key){
      case 'j':case 'J':
        control.moveBackward(ev.shiftKey, ev.ctrlKey);return stopEvent(ev)
      case 'k':
        control.togglePlay();return stopEvent(ev)
      case 'l': case 'L':
        control.moveForward(ev.shiftKey, ev.ctrlKey);return stopEvent(ev)
      case 'g': // se rendre au temps voulu (cf. manuel)
        control.goTo(Combo.current.textor.currentTime);return stopEvent(ev)
      case 's': // sauvegarde de l'analyse
        Analyse.current.save(); return stopEvent(ev)
      case 'p': // panneau des personnages
        Personnage.show(); return stopEvent(ev)
      case 'h': // Aide
        stopEvent(ev); Help.toggle(); return false;
      }
      // console.warn("[DOWN] Je dois apprendre à jouer le raccourci CMD + ", ev.key)
    }
    return true
  }
  static onUpCommon(ev){
    if ( ev.ctrlKey ) {
      // console.warn("[UP] Je dois apprendre à jouer le raccourci control + ", ev.key)
      switch(ev.key){
      case 'v':
        Video.toggleCurrentVideo()
        return stopEvent(ev)
      }
      return stopEvent(ev)
    } else if ( ev.metaKey ) {
    }
    return true
  }
}
window.onkeypress = KeyboardEventManager.onPress
window.onkeydown  = KeyboardEventManager.onDownCommon
window.onkeyup    = KeyboardEventManager.onUpCommon
