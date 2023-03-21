#!/bin/bash
VERSION=`cat VERSION.md`

# Parameters
INPUT_DIR=./data/raster
OUTPUT_DIR=./data/labo
FILENAME="COG_test_docker_real"
EXTENSION="tif"
EPSG="epsg:2154"

# Temporary folder
TEMP="tmp"

# Creates output folder
mkdir $OUTPUT_DIR -p

# Docker command
docker run --rm \
-v $INPUT_DIR:/input \
-v $OUTPUT_DIR:/output \
lidar_hd/cog:$VERSION \
./gdalCOG/script/gdal_COG.sh -i /input -o /output -p $EPSG -f $FILENAME -e $EXTENSION

# path to test
PATH_TMP=$OUTPUT_DIR/tmp
PATH_COG=$OUTPUT_DIR/$FILENAME.$EXTENSION

# existence folder output
if [ -d $OUTPUT_DIR ]; then
    echo "OK : Output folder $OUTPUT_DIR exists."
else
    echo "ERROR : Output folder $OUTPUT_DIR DOESN'T exist."
fi
# existence folder tmp
if [ -d $PATH_TMP ]; then
    echo "OK : Temporary file $PATH_TMP exists."
else
    echo "ERROR : Temporary file $PATH_TMP DOESN'T exist."
fi
# existence file COG
if [ -f $PATH_COG ]; then
    echo "OK : COG file $PATH_COG exists."
else 
    echo "ERROR : COG file $PATH_COG DOESN'T exist."
fi

# Delete output
echo Delete output
rm -f -r $OUTPUT_DIR

echo END.