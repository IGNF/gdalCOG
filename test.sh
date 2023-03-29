#!/bin/bash
INPUT_DIR=data/raster
OUTPUT_DIR=data/labo
FILENAME="COG_test"
EXTENSION="tif"
EPSG="epsg:2154"

mkdir $OUTPUT_DIR -p

./script/gdal_COG.sh -i $INPUT_DIR -o $OUTPUT_DIR -p $EPSG -f $FILENAME -e $EXTENSION

# remove output
echo Delete output
rm -r $OUTPUT_DIR

echo END.