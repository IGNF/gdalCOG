#!/bin/bash
INPUT_DIR=data/raster
OUTPUT_DIR=data/labo
FILENAME="COG_test"
EXTENSION="tif"
EPSG="epsg:2154"

mkdir $OUTPUT_DIR -p

./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION -w -m -s CUBIC -c LZW -d YES

# path to test
PATH_TMP=$OUTPUT_DIR/tmp_COG_test
PATH_WARP=$PATH_TMP/warp
PATH_WARP_FILE1=$PATH_WARP/test_data_0000_0000_LA93_IGN69.tif
PATH_WARP_FILE2=$PATH_WARP/test_data_0000_0001_LA93_IGN69.tif
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
# existence folder warp
if [ -d $PATH_WARP ]; then
    echo "OK : Temporary file $PATH_WARP exists."
else
    echo "ERROR : Temporary file $PATH_WARP DOESN'T exist."
    exit 1
fi
# existence files after warp
if [ -f $PATH_WARP_FILE1 ]; then
    echo "OK : Temporary file $PATH_WARP_FILE1 exists."
else
    echo "ERROR : Temporary file $PATH_WARP_FILE1 DOESN'T exist."
    exit 1
fi
if [ -f $PATH_WARP_FILE2 ]; then
    echo "OK : Temporary file $PATH_WARP_FILE2 exists."
else
    echo "ERROR : Temporary file $PATH_WARP_FILE2 DOESN'T exist."
    exit 1
fi
# existence file COG
if [ -f $PATH_COG ]; then
    echo "OK : COG file $PATH_COG exists."
else 
    echo "ERROR : COG file $PATH_COG DOESN'T exist."
    exit 1
fi

# remove output
echo Delete output
rm -f $PATH_TMP/$FILENAME.txt
rm -f $PATH_TMP/$FILENAME.vrt
rm -f $PATH_WARP/test_data_0000_0000_LA93_IGN69.$EXTENSION
rm -f $PATH_WARP/test_data_0000_0001_LA93_IGN69.$EXTENSION
rm -d $PATH_WARP
rm -d $PATH_TMP
rm -f $OUTPUT_DIR/$FILENAME.$EXTENSION
rm -d $OUTPUT_DIR

echo END.