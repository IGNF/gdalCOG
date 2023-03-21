# gdalCOG

## Présentation

Ce répertoire permet de créer un COG avec gdal en enchaînant les commandes `gdalbuildvrt` et `gdal_translate`.

## Utilisation

Si utilisation directe : linux. Sinon utiliser avec l'image docker.

### Utilisation directe

Cloner le répertoire et se placer à la racine.

Pour voir tous les paramètres :

`./script/gdal_COG.sh -h`

Paramètres :

    -i input directory
    -o output directory
    -p projection (défaut : "epsg:2154")
    -e extension des fichiers en entrée (défaut : ".tif")
    -f nom fichier en sortie (défaut : "COG")

Commande complète :

`./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION`


### Utilisation avec docker

A faire.

### Test

A la racine, lancer `./test.sh`

### Licence

Ce répertoire est sous licence CECILL-B (voir [LICENSE.md](https://github.com/IGNF/gdalCOG/blob/add_license/LICENSE.md)).