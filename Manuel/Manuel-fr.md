# Film Analyzor — Manuel

<a name="presentation"></a>

## Présentation

**Film Analyzor** est une application WAA qui permet d'analyser confortablement les films en offrant quelques outils utiles.

<a name="quick-use"></a>

## Utilisation rapide

> Cette partie décrit une utilisation rapide de l’application pour une (re)prise en main rapide.

<a name="preparation"></a>

### Création à partir d’un dossier contenant la vidéo

S’il existe déjà un dossier contenant la vidéo (en `mp4`), il suffit d’ouvrir un Terminal à ce dossier et de jouer la commande **`film`**. L’application détecte le dossier et demande s’il faut le transformer en dossier d’analyse de film.

### Création ex-nihilo

* créer un dossier pour l'analyse,

* y placer la vidéo du film (elle doit être au format `mp4` — avec les sous-titres si nécessaire),

* elle peut être dupliquée dans le dossier `me/Sites/FilmAnalyzor` (mais si elle se trouve dans le dossier de l’application, une copie peut être faite)

* dans le dossier de l’analyse, créer un fichier **\`data.ana.yaml\`** et y définir :

  ~~~yaml
  # in data.ana.yaml
  titre: <titre du film
  path: </path/absolute/to/folder/analyse>
  # Si la vidéo porte un autre nom que le dossier :
  video: <nom du fichier de la vidéo>
  ~~~
  
* dans ce dossier, créer également un fichier **`analyse.ana.txt`** qui peut rester vide (il contiendra le texte de l'analyse)

* on lance l’application à l’aide de la commande générique `film` (ou, si la commande n'est pas installée, en ouvrant une fenêtre de Terminal dans le dossier de l’application et en jouant `ruby analyzor.rb`),

* si nécessaire, régler les paramètres du navigateur pour autoriser les commandes de lecture ([voir pour Firefox]( https://mzl.la/3pbxA8a)),

* quand la vidéo est chargée, on peut commencer à [analyser le film](#analyser-film).

<a name="personnages"></a>

### Les personnages

Pour une écriture plus rapide, on peut définir les personnages du film, qui deviendront des snippets. C’est-à-dire que si « JOHN » est représenté par « J », il suffira de taper `J[TAB]` dans l’analyse pour écrire le personnage sans erreur et rapidement.

<a name="define-personnages"></a>

#### Pour définir un ou des personnages :

* ouvrir le panneau personnage en cliquant sur le bouton « Personnages » ou en jouant le raccourci `⌘ P`,
* si c'est le premier personnage, remplir les champs,
* si c'est un autre personnage, cliquer sur le bouton « ➕ » et remplir les champs du personnage,
* cliquer sur « Définir » quand tous les personnages ont été définis.

<a name="use-marque-personnages"></a>

#### Utilisation efficace des personnages

Plutôt que d'écrire en toutes lettres le personnages dans le texte de l'analyse, on a meilleur temps d'utiliser les snippets définis en [définissant les personnages](#define-personnages).
Dans le texte de l'analyse, il suffit ensuite de taper simplement la ou les quelques lettres définies dans le premier champ du personnage (appelé « Snippet ») et jouer la touche Tabulation. Aussitôt un marque pour ce personnage est ajoutée, reconnaissable à ses deux points qui le précèdent : `··Mon Personnage`

> Ces deux points sont importants car ils permettront, plus tard, d'estimer le temps de présence du personnage dans les scènes, etc.

Mais attention : chaque fois qu'un personnage est mentionné de cette manière dans cette scène, l'analyseur considèrera que le personnage fait partie de la scène, et ajoutera donc cette scène aux scènes du personnage. En d'autres termes, pour faire une carte conforme des présences de personnages, il ne faut indiquer de cette manière que les personnages qui jouent dans la scène. Si des mentions doivent être faites à d'autres personnages (par exemple si les personnages présents dans la scène parlent d'un autre personnage non présent) il faudra l'écrire en toutes lettres ou supprimer ses deux points le précédant.

<a name="analyser-film"></a>

### Analyser le film

* la première chose à faire est de **définir le zéro-absolu du film**. Par convention, on lui met la valeur de la toute première image :
  * faire défiler le film jusqu’à la première image,
  * se servir des raccourcis `⌘ J` et `⌘ L` pour ajuster la position,
  * dans le menu « Options » sous la vidéo principale, choisir l’item « Zéro absolu »
  * => Sa valeur est mise au temps courant

    > Noter que cela ne change en rien les temps affichés ou imprimés dans le texte de l’analyse. Mais cela servira à produire le texte final ainsi qu’à calculer la structure.

* se placer dans le champ de texte pour commencer à écrire l’analyse,
* se souvenir de la [règle des doubles chariots](#regle-double-chariot),
* on peut indiquer un premier temps en jouant le snippet `t[TAB]`. Cela écrit le temps courant sur la ligne du curseur. **Surtout, ne rien mettre d’autre que ce temps sur la ligne**.
* si c’est une scène, ajouter simplement « `SCENE <Résumé>`» sur la ligne (par exemple avec le snippet `s[TAG]`), 
* penser à passer une ligne après le résumé, selon la [règle des doubles chariots](#regle-double-chariot),
* rédiger la description de la scène, si c’est une scène
* partout où l'on veut retenir un temps, on inscrit le time code (`t[Tab]`) puis on écrit ce qu'on veut en dessous. S'il n'y a pas de ligne vide sous le time-code, on considère que tout ce qui le suit fait partie de ce temps, selon la [règle des doubles chariots](#regle-double-chariot),
* dans la description de la scène (attention : pas forcément le résumé), on peut [utiliser les marques de personnages](#use-marque-personnages) pour mieux les identifier,

<a name="identify-scene"></a>

#### Identifier une scène

*Identifier une scène* permet à l'analyseur de savoir qu'une scène se trouve à tel ou tel endroit.

Pour l'identifier, on procède ainsi :

* placer un time code au moment de la scène (`t[Tab]`),
* SOUS ce time code, placer une marque de scène (`s[Tab]`),
* définir le résumé de la scène après la marque `SCENE`,
* passer une ligne pour commencer la description de la scène.

---

<a name="ui"></a>

## L’interface

<a name="combos"></a>

### Les combos

Les parties principales de l’interface sont les deux « combos » qui contiennent l’image de la vidéo. Ils sont constitués :

* d’une fenêtre pour l’image de la vidéo,
* d’un contrôleur qui permet de régler l’image de la vidéo (avec les boutons de démarrage, etc.)
* un menu d’options
* un champ pour entrer l’analyse (pour le moment, seul le champ du premier combo est utile.

<a name="menu-options"></a>

#### Menu options

C’est le menu qui se trouve tout à gauche sous la fenêtre de la vidéo. Il permet de régler toutes les options concernant l’analyse ou la fenêtre vidéo courante.

---

<a name="video"></a>

## La vidéo du film

* La vidéo de référence doit être au format `mp4`.
* elle doit se trouver dans le dossier de l’analyse (elle est mise dans `FilmAnalyzor/videos/` au moment de son analyse)

Si la vidéo porte un des noms suivants, ce nom n’a pas besoin d’être défini dans le fichier `data.ana.yaml` :

* **`<nom dossier>.mp4`** (par exemple `Drive/Drive.mp4`)
* **`<nom dossier>-us.mp4`** (par exemple `Drive/Drive-us.mp4`)
* **`<nom dossier>-fr.mp4`** (par exemple `Drive/Drive-fr.mp4`)

> `-us` et `-fr` ne doivent pas déterminer la langue du film (il doit être toujours dans sa langue originale) mais la langue du sous-titre.

---

<a name="operations"></a>

## Opérations

#### Définir le « zéro absolu »

Le « zéro absolu » de la vidéo (c’est-à-dire la première image) se règle dans le premier [menu options](#menu-options) du premier [combo](#combos). C’est le premier menu. Il suffit de se placer sur cette première image et d’appeler ce menu.

#### Régler le démarrage automatique

Pour que la vidéo se mette en route quand on rejoint un temps quelconque, l’auto-démarrage doit être activé dans le [menu des options du combo](#menu-options). Noter que chaque combo peut avoir son propre réglage.

---

<a name="keyboard-shortcuts"></a>

## Combinaisons clavier (commandes)

L’application comporte de nombreux raccourcis clavier qui permettent de contrôler la vidéo.

| Description                                                  | Raccourci |
| ------------------------------------------------------------ | --------- |
| Mettre en route la lecture                                   | ⌘ K       |
| Une image en arrière (vidéo courante)                        | ⌘ J       |
| Une seconde en arrière                                       | ⌘ ⇧ J     |
| Une image en avant                                           | ⌘ L       |
| Une seconde en avant                                         | ⌘ ⇧ L     |
| Mettre la vidéo courante au premier time-code avant le curseur ([?](#goto-time-avant-cursor)) | ⌘ G       |
| Placer un marqueur temporel ([?](#go-to-marker))             | ⌘ m       |
| Se rendre au marqueur temporel défini                        | ⌘ g       |
| Se rendre au temps défini sous le curseur                    | ⌘ g       |
| Basculer vers l’autre vidéo                                  | ⌃ v       |
| Passer seulement à la ligne (sinon [une ligne est naturellement sautée](#regle-double-chariot)) | ⌘⇧↩︎       |



<a name="goto-time-avant-cursor"></a>

### Aller au temps du curseur (dans la vidéo voulue)

Quand on se trouve à un endroit dans le texte de l’analyse, on peut demander au contrôleur de rejoindre la scène dont il est question en jouant le raccourci clavier `⌘ G` (noter le « G » majuscule). 

Pour ce faire, l’application remonte jusqu’à trouver le premier temps seul sur une ligne (qu’on a pu placer grâce au snippet `t` par exemple.

### Aller au temps sous le curseur

Jouer `⌘ g` (« g » minuscule) pour aller au temps sous le curseur. La différence avec le « G » majuscule, ici, est que l’application ne remonte pas pour trouver un temps. Si le curseur se trouve sur une horloge (seule sur une ligne), on rejoint ce temps, sinon on rejoint le marqueur défini (cf. ci-dessous). C’est seulement s’il n’y a pas de marqueur défini qu’on recherche le temps de scène.

<a name="go-to-marker"></a>

### Marqueur temporel

Parfois, on a besoin de remonter souvent à un temps qu’on n’a pas forcément mis en timecode dans le texte. Pour ce faire, on place à l’endroit voulu un marqueur temporel à l’aide de `⌘ m` (« m » comme « marqueur ») et on y revient à l’aide de `⌘ g` (« g » comme « go »).

> Noter que si on utilise « g » majuscule au lieu de « g » minuscule, l’interface recherchera dans le texte actif le premier timecode et s’y rendra.



---

<a name="snippets"></a>

## Snippets

Des snippets permettent de gérer facilement les éléments :

> Tous ces snippets doivent être tapés puis suivis d'une touche tabulation.

| Description | Snippet |
| --- | --- |
| Insert le temps courant sur la ligne | `t` |
| [Identifier une scène](#identify-scene) (Insert le mot-clé « SCENE » sur la ligne) | `s` |
| Insert le mot-clé « SEQUENCE » sur la ligne (reconnaissance d’une séquence) | `sq` |
| Insérer la marque « OBJECTIF » | `o` |

---

<a name="principes"></a>

## Principes

<a name="regle-double-chariot"></a>

### Règle des doubles chariots

Ce principe veut que tout élément de l’analyse doit être séparé par des doubles chariot.

> Mais noter qu’on s’en fiche quand on interface l’analyse. Par exemple, pour produire les analyses de film dans la collection « Les Leçons du cinéma », c’est le module produisant le livre qui parse le fichier d’analyse.

Cela commence avec le temps d’une scène :

~~~
0:00:12:25
SCENE La deuxième scène
~~~

Le fait que `SCENE` soit « collé » au timecode ci-dessus indique que ce temps contient cette scène.

Dans :

~~~
SCENE Le début du résumé
Une deuxième ligne du résumé
Une troisième ligne de résumé

Cette ligne marque le début de la description de la scène.
~~~

… le résumé est composé de trois lignes. La première ligne sert toujours de résumé court.

Il en va de même pour tout élément, par exemple pour la définition d’un objectif : 

~~~
Description de la scène.

OBJECTIF John doit retourver son fils
L'objectif un peu plus détaillé.

La suite de la description de la scène, après une ligne vide.
~~~



## Annexe

### Création de la commande `film`

~~~
ln -s /Users/me/Programmes/FilmAnalyzor/analyzor.rb /usr/local/bin/film
~~~

### Script d’ouverture de l’analyse

Pour ne pas avoir à ouvrir une fenêtre de Terminal et taper `film`, on peut simplement copier le binaire `bin/run` dans le dossier de l’analyse (le dossier principal, contenant les deux fichiers `data.ana.yaml` et `analyse.ana.txt`. Il suffit de double-cliquer sur ce fichier pour lancer l’analyse en question.
