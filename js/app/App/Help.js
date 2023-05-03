'use strict';

const HELP_TEXT = 'Manuel/Manuel-fr-SEND.md'

const HELP_TEXT_RAW = `


---

<a name="presentation"></a>

## Présentation

L'application Film Analyzor permet d'analyser confortablement des films, pour en sortir ensuite l'analyse (le synopsis temporisé, la structure, etc.)

---

<a name="installation"></a>

## Installation

Pour procéder à l'analyse d'un film :

* mettre sa vidéo mp4 dans le dossier 'me/Sites/FilmAnalyzor',
* lui créer un dossier,
* dans ce dossier, créer un fichier \`data.ana.yaml\` et y définir :
  
  ~~~yaml
  titre: <titre du film
  zero: 0
  path: </path/absolute/to/folder/analyse>
  video: <nom du fichier de la vidéo>
  ~~~

* dans ce dossier, créer également un fichier \`texte.ana.txt\` qui peut rester vide (il contiendra le texte de l'analyse)

---

<a name="premiers_pas"></a>

## Premiers pas


<a name="snippets"></a>

## Snippets

Les snippets permettent de gagner beaucoup de temps.

### Snippets pour les éléments importants

### Snippets pour les personnages

`
