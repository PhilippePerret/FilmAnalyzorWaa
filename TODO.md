# Todo list

* "protéger" absolument l'enregistrement
  1. sur une session de travail, faire un backup systématique de chaque enregistrement
    - le détruire le lendemain
  2. l'enregistrement se faisant séquentiellement, faire disparaitre le bouton "Enregistre" + mettre un texte clignotant pendant tout le temps que ça dure
  3. essayer de générer une erreur en cas de gros problème, comme ça arrive (en disant qu'il ne faut surtout pas fermer la fenêtre pour ne pas perdre le texte, qu'il faut le copier-coller quelque part)
      (comment le repérer ? comment remonter une erreur comme celle qui se produit)

      ~~~
      #######
      Impossible d'envoyer les données suivantes :
      #######
      {\"class\":\"Analyse.current\",\"method\":\"saveTexte\",\"data\":{\"ok\":true}}
      #######
      MESSAGE D'ERREUR : #<Selenium::WebDriver::Error::NoSuchWindowError: Browsing context has been discarded>
      #######
      ~~~

* Supprimer les lignes verticales qui sont ajoutées au PFA relatif (dans le test).


Cf `ghi list -L bug` pour voir les bugs 
Cf `ghi list` (sauf pour une mini list rapide à faire immédiatement, à placer ci-dessus)

## Questions

* faut-il synchroniser tous les champs de texte (textor de la vidéo ?)
