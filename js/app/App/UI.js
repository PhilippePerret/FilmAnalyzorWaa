'use strict';

class UI {
  static prepare(){
    this.espaceButtonTitle()
  }

  /**
  * Pour que la souris ne masque pas le début du title des boutons
  */
  static espaceButtonTitle(){
    document.querySelectorAll('button').forEach(button => {
      if ( button.title ) {
        button.title = '      ' + button.title
      }
    })
  }
}
