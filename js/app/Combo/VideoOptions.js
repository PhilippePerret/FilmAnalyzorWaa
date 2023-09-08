'use strict';
/**
* Class VideoOptions
* -------------------
* Gestion des options de la vidéo (Video@options)
* 
*/

class VideoOptions {

  constructor(video){
    this.video = video
    this.data  = {} // à la création de l'analyse
  }

  /*
  |  Public methods
  */

  get zero(){return this.get('zero')}
  get start_on_go(){return this.get('start_on_go')}

  /*
  |  --- Observer Method ---
  */

  onChangeOption(ev) {
    const optid = this.menu.value
    this.menu.selectedIndex = 0
    switch(optid){
    case 'zero':
      /* - On doit prendre le temps courant - */
      this.data.zero = this.video.currentTime
      break
    case 'adapt_to_window':
      /* - On doit adapter la vidéo à la fenêtre courante - */
      this.video.adaptToWindow()
      break
    case 'adapt_to_video':
      this.video.adaptWindowToVideo()
      break
    case 'brightness':
      this.video.changeBrightness()
      break;
    default:
      /* - Option dont on doit inverser la valeur - */
      this.data[optid] = !this.data[optid]
    }
    /*
    |  On règle toujours l'option
    */
    this.setOption(optid)
    /* - On indique l'analyse est modifiée - */
    Analyse.current.isModified = true
  }

  prepare(){
    this.menu.selectedIndex = 0
    listen(this.menu,'change', this.onChangeOption.bind(this))
  }

  /**
  * Réglage des <option> du menu
  */
  set(data){
    this.data = data
    this.setOption('zero')
    this.setOption('start_on_go')
    this.setOption('brightness')
  }

  /**
  * Pour régler visuellement la valeur de l'option
  */
  setOption(optid){
    switch(optid){
    case 'zero':
      this.option('zero').innerHTML = `Zéro absolu : ${s2h(this.data.zero || 0)}`
      break
    case 'start_on_go':
      this.option('start_on_go').innerHTML = this.start_on_go ? '☒ Démarrer au go' : '☐ Démarrer au go'
      break
    case 'brightness':
      this.option('brightness').innerHTML = `Changer la luminosité (${this.video.brightness})`
      break
    }
  }

  /**
  * @return [Any] l'option d'identifiant +optid+
  */
  get(optid){
    return this.data[optid]
  }

  /**
  * Retourne le DOMElement de l'option de classe +optid+
  */
  option(optid){
    return DGet(`option[value="${optid}"]`, this.menu)
  }

  get menu(){
    return this._menu || (this._menu = DGet('select.menu-options', this.video.combo.obj))
  }
}
