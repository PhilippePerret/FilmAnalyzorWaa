'use strict';
/**
* Class Scene
* -----------
* Gestion des scènes
*/

class Scene {

  /**
  * Affichage des scènes (pour en rejoindre une)
  */
  static display(){
    this.scenes = this.getScenesInText()
    this.panel.setContent(this.buildListingScenes(this.scenes))
    this.setKeyevents()
    this.panel.show()
    this.observe()
    this.selectScene(0)
  }

  static onHide(){
    this.unsetKeyevents()
  }

  static setKeyevents(){
    this.prevkeyup = window.onkeyup
    this.prevkeydown = window.onkeydown
    window.onkeyup    = this.onKeyUp.bind(this)
    window.onkeydown  = this.onKeyDown.bind(this)
  }
  static unsetKeyevents(){
    window.onkeyup    = this.prevkeyup
    window.onkeydown  = this.prevkeydown
  }

  static onKeyUp(ev){
    switch(ev.key){
    case 'ArrowUp':
      if ( this.currentScene.index > 0 ) {
        this.selectScene(this.currentScene.index - 1)
      }
      break
    case 'ArrowDown':
      if ( this.currentScene.index < this.scenes.length - 1 ){
        this.selectScene(this.currentScene.index + 1) 
      }
      break
    case 'g':
      Video.current.currentTime = this.currentScene.time
      break
    case 'Enter':
      Video.current.currentTime = this.currentScene.time
      this.panel.hide()
      break
    default:
      // console.log("-> onKeyUp ", ev.key)
    }
  }
  static onKeyDown(ev){

  }

  static observe(){
    this.scenes.forEach(scene => {
      listen(scene.obj, 'click', this.onSelectScene.bind(this, scene))
    })
  }

  static onSelectScene(scene, ev){
    this.selectScene(scene.index)
    return stopEvent(ev)
  }

  static get panel(){
    return this._panel || (this._panel = this.initPanel())
  }

  static buildListingScenes(scenes){
    return '<div id="listing-scenes">' + scenes.map(scene => {
      return scene.to_item
    }).join('') + '</div>'
  }

  static selectScene(scene_index){
    if ( this.currentScene ) this.currentScene.deselect()
    this.currentScene = this.scenes[scene_index]
    this.currentScene.select()
  }

  static get listing(){
    return this._listing || (this._listing = DGet('#listing-scenes'))
  }

  /*
  |  ------------- INSTANCES ---------------
  */
  constructor(data){
    this.data = data
    this.numero = this.data.numero
    this.index  = this.numero - 1
    this.time   = this.data.time
  }

  select(){
    this.obj.classList.add('selected')
  }
  deselect(){ this.obj.classList.remove('selected')}

  get to_item(){
    return `<div id="scene-item-${this.numero}" class="scene"><span class="numero">${this.numero}.</span><span class="resume">${this.data.resume}</span><span class="time">${s2h(this.data.time, false)}</span></div>`
  }

  get obj(){return DGet(`#scene-item-${this.numero}`, Scene.listing)}

  /*
  |  ---------------- Private Methods ---------------
  */

  /**
   * @private
   * 
  * Pour récupérer les scènes dans le texte de l'analyse
  * 
  * @return [Array<Scene>] Liste des scènes, dans l'ordre
  */
  static getScenesInText(){
    /*
    |  On boucle sur toutes les lignes du texte pour récupérer les
    |  temps et les scènes
    */
    var scenes = []
    var numero_scene  = 0
    var temps_courant = 0
    var resume
    Analyse.current.texte.split("\n").forEach( line => {
      line = line.trim()
      if ( REG_TIME_MARK.exec(line) !== null) {
        temps_courant = h2s(REG_TIME_MARK.exec(line)[0])
      } else if ( line.substring(0, 5) == 'SCENE' ) {
        ++ numero_scene
        resume = line.substring(5, line.length) || `Scène ${numero_scene}` 
        scenes.push(new Scene({numero: numero_scene, resume: resume, time: temps_courant}))
      }
    })
    return scenes
  }

  /**
  * @private
  * 
  * Retourne le panneau pour la liste des scènes
  * 
  */
  static initPanel(){
    return new Panel({
        id: "panneau-scenes"
      , mainTitle: 'Liste des scènes'
      , options: {movable:true, onHide: this.onHide.bind(this), position_x:'right'}
    })
  }
}
