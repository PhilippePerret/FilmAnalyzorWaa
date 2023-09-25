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
      /*
      |  Les commandes principales pour commander l'interface
      */
      const combo = Video.current.combo
      const control = combo.controller
      switch ( ev.key ){
      case 'g': // se rendre au temps voulu ou au marqueur (cf. manuel)
        control.goToTextTimeOrCurrentMarker(); return stopEvent(ev)
      case 'G': // se rendre au premier temps trouvé dans le texte
        control.goTo(Combo.current.textor.currentTime); return stopEvent(ev)
      case 'h': // Aide
        stopEvent(ev); QuickHelp.toggle(); return false;
      case 'j':case 'J': // reculer
        control.moveBackward(ev.shiftKey, ev.ctrlKey);return stopEvent(ev)
      case 'k': // Jouer la vidéo
        control.togglePlay();return stopEvent(ev)
      case 'l': case 'L': // avancer
        control.moveForward(ev.shiftKey, ev.ctrlKey);return stopEvent(ev)
      case 'm': case 'M': // placer le marqueur
        control.defineMarker();return stopEvent(ev)
      case 'p': // panneau des personnages
        Personnage.toggle(); return stopEvent(ev)
      case 's': // sauvegarde de l'analyse
        stopEvent(ev); Analyse.current.save(); return false
      case 'S':
      }
      // console.warn("[DOWN] Je dois apprendre à jouer le raccourci CMD + ", ev.key)
    }
    return true
  }
  static onUpCommon(ev){
    /*
    |  Avec la touche CTRL
    */
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
