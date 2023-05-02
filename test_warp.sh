#!/bin/bash
INPUT_DIR=data/raster
OUTPUT_DIR=data/labo
FILENAME="COG_test"
EXTENSION="tif"
EPSG="epsg:2154"

mkdir $OUTPUT_DIR -p

./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION -w

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

# remove output
echo Delete output
rm -r $OUTPUT_DIR

echo END.