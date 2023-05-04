# gdalCOG

## Présentation

Ce répertoire permet de créer un COG avec gdal en enchaînant les commandes (`gdalwarp` si nécessaire) `gdalbuildvrt` et `gdal_translate`.

## Utilisation

Si utilisation directe : linux. Sinon utiliser avec l'image docker associée.

### Utilisation directe

Cloner le répertoire et se placer à la racine.

Pour voir tous les paramètres :

`./script/gdal_COG.sh -h`

Paramètres :

    -i | --input        (chemin dossier en entrée contenant les rasters)
    -o | --output       (chemin dossier en sortie)
    -p | --projection   (défaut : "epsg:2154")
    -e | --extension    (extension des rasters en entrée) (défaut : "tif")
    -f | --filename     (nom du fichier en sortie) (défaut : "COG")
    -w | --warp         (étape optionnelle : utilisation de gdalwarp) (défaut : non activée)
    -r | --remove       (supprime les fichiers et dossiers intermédiaires contenus dans `/tmp`) (défaut : non activée)

Commande basique (avec toutes les options par défaut) :

`./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR`

Commande avec options (projection, extension, filename et remove) :

`./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION -r`

### Cas particulier : utilisation gdalwarp

L'utilisation de `gdalwarp` en début de chaîne permet de gérer le cas où l'origine des coordonnées se situe en bas à gauche (lower-left) de l'image. En effet, `gdalbuildvrt` nécessite que l'origine des coordonnées se situe en haut à gauche (upper-left) de l'image.

Pour utiliser cette option, il faut rajouter `-w` à la commande.

Commande (avec gdalwarp pour seule option):

`./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -w`


### Utilisation avec docker

Cloner le répertoire.

Se placer dans le dossier `docker` et construire l'image `./build.sh`.

Lancer le script `gdal_COG.sh` sous docker. 

Exemple avec les mêmes paramètres que l'exemple précédent :

`docker run --rm \`

`-v $INPUT_DIR:input \`

`-v $OUTPUT_DIR:output \`

`lidar_hd/cog:$VERSION \`

`./script/gdal_COG.sh -i /input -o /output -p $EPSG -f $FILENAME -e $EXTENSION`


### Tests

 Test sans docker : à la racine, lancer `./test.sh`.

Test avec l'étape gdalwarp : à la racine, lancer `./test_warp.sh`.

 Test avec l'option remove : à la racine, lancer `./test_remove.sh`.
 
 Test avec docker : après avoir créé l'image docker, lancer à la racine `./test_docker.sh`.
 ATTENTION : Dans l'image Docker, dossiers et fichiers sont créés avec l'utilisateur `root`. Une fois le test avec docker joué, il faut supprimer manuellement tout le dossier `/data/labo` afin de pouvoir jouer un autre test.


### Déploiement sur le nexus ign

Se placer dans le dossier `docker` :

`./deploy.sh`

### Licence

Ce répertoire est sous licence CECILL-B (voir [LICENSE.md](https://github.com/IGNF/gdalCOG/blob/add_license/LICENSE.md)).