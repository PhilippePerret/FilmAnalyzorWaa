'use strict';

class App {


  static onReady(){

    console.info("WAA.mode_test = ", WAA.mode_test)
    /*
    |  Préparation de l'interface
    */
    UI.prepare()

    Combo.prepareFirstCombo()

  }

  /**
  * Pour repartir à zéro
  * 
  * Pour le moment, utilisé seulement par les tests
  */
  static resetAll(){

  }

  /**
  * Pour remonter une erreur depuis le serveur avec WAA.
  * (WAA.send(class:'App',method:'onError', data:{:message, :backtrace}))
  */
  static onError(err){
    erreur(err.message + " (voir en console)")
    console.error(err.message)
    console.error(err.backtrace)
  }
  
} // /class App
