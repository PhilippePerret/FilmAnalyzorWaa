
---

[TOC]

---


{À implémenter}

#### Analyse du film

* la première chose à faire est de **définir le zéro-absolu du film**. Par convention, on le définit à la toute première image :

  * faire défiler le film jusqu’à la première image,

  * se servir des raccourcis `⌘ J` et `⌘ L` pour ajuster la position,

  * dans le menu « Options » sous la vidéo principale, choisir l’item « Zéro absolu »

  * => Sa valeur est mise au temps courant

    > Noter que cela ne change en rien les temps affichés ou imprimés dans le texte de l’analyse. Mais cela servira à produire le texte final ainsi qu’à calculer la structure.

* Se placer dans le champ de texte pour commencer l’analyse

* On peut indiquer un premier temps en jouant le snippet `t[TAB]`. Cela écrit le temps courant sur la ligne du curseur. **Surtout, ne rien mettre d’autre que ce temps sur la ligne**.

* Si c’est une scène, ajouter simplement « SCENE » sur la ligne (par exemple avec le snippet `s[TAG]`), 

* rédiger la description de la scène, si c’est une scène

---

## La vidéo

* La vidéo de référence doit être au format `mp4`.
* elle doit se trouver dans le dossier `/me/Sites/FilmAnalyzor` (donc dans mon dossier site)
* en fait, la déplacer simplement là quand on analyse le film ({TODO: À l’avenir, on pourra prévoir une procédure qui mette le film là, mais la copie risque d’être un peu longue…}



---

## Raccourcis clavier

L’application comporte de nombreux raccourcis clavier qui permettent de contrôler la vidéo.

| Description                                                  | Raccourci |
| ------------------------------------------------------------ | --------- |
| Mettre en route la lecture                                   | ⌘ K       |
| Une image en arrière (vidéo courante)                        | ⌘ J       |
| Une seconde en arrière                                       | ⌘ ⇧ J     |
| Une image en avant                                           | ⌘ L       |
| Une seconde en avant                                         | ⌘ ⇧ L     |
| Mettre la vidéo courante au premier time-code avant le curseur ([comprendre](#goto-time-avant-cursor) | ⌘ G       |
| Basculer vers l’autre vidéo                                  | ⌃ v       |



<a name="goto-time-avant-cursor"></a>

### Aller au temps du curseur

Quand on se trouve à un endroit dans le texte de l’analyse, on peut demander au contrôleur de rejoindre la scène dont il est question en jouant le raccourci clavier `⌘ g`. 

Pour ce faire, l’application remonte jusqu’à trouver le premier temps seul sur une ligne (qu’on a pu placer grâce au snippet `t` par exemple.



---

## Snippets

Des snippets permettent de gérer facilement les éléments :

> Tous ces snippets doivent être tapés puis suivis d'une touche tabulation.

| Description | Snippet |
| --- | --- |
| Insert le temps courant sur la ligne | t |
| Insert le mot-clé « SCENE » sur la ligne (reconnaissance d’une scène) | s |
| Insert le mot-clé « SEQUENCE » sur la ligne (reconnaissance d’une séquence) | sq |
