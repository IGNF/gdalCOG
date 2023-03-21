# gdalCOG

## Présentation

Ce répertoire permet de créer un COG avec gdal en enchaînant les commandes `gdalbuildvrt` et `gdal_translate`.

## Utilisation

Si utilisation directe : linux. Sinon utiliser avec l'image docker associée.

### Utilisation directe

Cloner le répertoire et se placer à la racine.

Pour voir tous les paramètres :

`./script/gdal_COG.sh -h`

Paramètres :

    -i input (dossier en entrée contenant les rasters)
    -o output (dossier en sortie)
    -p projection (défaut : "epsg:2154")
    -e extension (extension des rasters en entrée) (défaut : "tif")
    -f filename (nom du fichier en sortie) (défaut : "COG")

Commande complète :

`./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION`


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
 
 Test avec docker : après avoir créé l'image docker, lancer à la racine `./test_docker.sh`.

### Déploiement sur le nexus ign

Se placer dans le dossier `docker` :

`./deploy.sh`

### Licence

Ce répertoire est sous licence CECILL-B (voir [LICENSE.md](https://github.com/IGNF/gdalCOG/blob/add_license/LICENSE.md)).