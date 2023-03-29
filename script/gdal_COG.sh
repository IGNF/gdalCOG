#!/bin/bash
set -e

# Default parameters
INPUT_DIR="/input"
OUTPUT_DIR="/output"
EPSG="epsg:2154"
EXTENSION="tif"
FILENAME="COG"

# Temporary folder
TEMP="tmp"

USAGE="""
Usage ./main.sh -i INPUT_DIR -o OUTPUT_DIR -p EPSG -e EXTENSION -f FILENAME\n
"""
# Parse arguments in order to possibly overwrite paths
while getopts "h?i:o:p:e:f:" opt; do
  case "$opt" in
    h|\?)
      echo -e ${USAGE}
      exit 0
      ;;
    i)  INPUT_DIR=${OPTARG}
      ;;
    o)  OUTPUT_DIR=${OPTARG}
      ;;
    p)  EPSG=${OPTARG}
      ;;
    e)  EXTENSION=${OPTARG}
      ;;
    f)  FILENAME=${OPTARG}
      ;;
  esac
done

# Creates temporary folder
mkdir $OUTPUT_DIR/$TEMP -p

# List of tiff
echo Create list of .$EXTENSION
ls -d $INPUT_DIR/*.$EXTENSION > $OUTPUT_DIR/$TEMP/list.txt

if [ ! -s "$OUTPUT_DIR/$TEMP/list.txt" ]; then
    echo "File is empty"
    exit 0 
else
    echo "File is not empty"
fi

# VRT
echo Build VRT
gdalbuildvrt -input_file_list $OUTPUT_DIR/$TEMP/list.txt $OUTPUT_DIR/$TEMP/VRT.vrt

# COG
echo Build COG
# ARGS :
# BIGTIFF=[YES/NO/IF_NEEDED/IF_SAFER] : YES forces BigTIFF instead of classic TIFF because image will be larger than 4GB.
# COMPRESS=[NONE/LZW/JPEG/DEFLATE/ZSTD/WEBP/LERC/LERC_DEFLATE/LERC_ZSTD/LZMA] : LZW/DEFLATE/ZSTD compressions can be used with the PREDICTOR creation option. ZSTD compress more.
# PREDICTOR=[YES/NO/STANDARD/FLOATING_POINT] : YES => standard predictor=2 (use if integer data type) instead of predictor=3 (use if floating point data type but less efficient here)
gdal_translate \
--config GDAL_DISABLE_READDIR_ON_OPEN TRUE \
-co BIGTIFF=YES \
-co COMPRESS=LZW \
-co PREDICTOR=YES \
-a_srs $EPSG \
-of COG \
$OUTPUT_DIR/$TEMP/VRT.vrt \
$OUTPUT_DIR/$FILENAME.$EXTENSION

# Deletes contents of temporary folder
rm $OUTPUT_DIR/$TEMP/*.txt
rm $OUTPUT_DIR/$TEMP/*.vrt