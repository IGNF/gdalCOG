#!/bin/bash
INPUT_DIR=data/raster
OUTPUT_DIR=data/labo
FILENAME="COG_test"
EXTENSION="tif"
EPSG="epsg:2154"

mkdir $OUTPUT_DIR -p

./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION -r

# path to test
PATH_TMP=$OUTPUT_DIR/tmp
PATH_SUBTMP=$PATH_TMP/tmp*
PATH_TXT=$PATH_SUBTMP/$FILENAME.txt
PATH_VRT=$PATH_SUBTMP/$FILENAME.vrt
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
# not existence file txt
if [ -f $PATH_TXT ]; then
    echo "ERROR : TXT file $PATH_TXT exists."
    exit 1
else 
    echo "OK : TXT file $PATH_TXT DOESN'T exist."
fi
# not existence file vrt
if [ -f $PATH_VRT ]; then
    echo "ERROR : VRT file $PATH_VRT exists."
    exit 1
else 
    echo "OK : VRT file $PATH_VRT DOESN'T exist."
fi
# existence file COG
if [ -f $PATH_COG ]; then
    echo "OK : COG file $PATH_COG exists."
else 
    echo "ERROR : COG file $PATH_COG DOESN'T exist."
    exit 1
fi

echo END.

# remove output
echo Delete output
rm -d $PATH_SUBTMP
rm -d $PATH_TMP
rm -f $OUTPUT_DIR/$FILENAME.$EXTENSION
rm -d $OUTPUT_DIR

echo END.