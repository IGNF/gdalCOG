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
docker run --rm --userns=host \
-v $INPUT_DIR:/input \
-v $OUTPUT_DIR:/output \
lidar_hd/cog:$VERSION \
./gdalCOG/script/gdal_COG.sh -i /input -o /output -p $EPSG -f $FILENAME -e $EXTENSION

# path to test
PATH_TMP=$OUTPUT_DIR/tmp
PATH_WARP=$PATH_TMP/warp
PATH_COG=$OUTPUT_DIR/$FILENAME.$EXTENSION

# existence folder output
if [ -d $OUTPUT_DIR ]; then
    echo "OK : Output folder $OUTPUT_DIR exists."
else
    echo "ERROR : Output folder $OUTPUT_DIR DOESN'T exist."
    exit 1
fi
# existence folder tmp
if [ -d $PATH_TMP ]; then
    echo "OK : Temporary file $PATH_TMP exists."
else
    echo "ERROR : Temporary file $PATH_TMP DOESN'T exist."
    exit 1
fi
# existence file txt
if [ -f $PATH_TXT ]; then
    echo "OK : TXT file $PATH_TXT exists."
else 
    echo "ERROR : TXT file $PATH_TXT DOESN'T exist."
    exit 1
fi
# existence file vrt
if [ -f $PATH_VRT ]; then
    echo "OK : VRT file $PATH_VRT exists."
else 
    echo "ERROR : VRT file $PATH_VRT DOESN'T exist."
    exit 1
fi
# existence file COG
if [ -f $PATH_COG ]; then
    echo "OK : COG file $PATH_COG exists."
else 
    echo "ERROR : COG file $PATH_COG DOESN'T exist."
    exit 1
fi

# Outputs can't be deleted by standard user because in docker folders and files are created as root.

echo Delete manually the folder /data/labo in order to run other tests.
echo END.