#!/bin/sh
set -e

# Default parameters
INPUT_DIR=None
OUTPUT_DIR=None
EPSG="epsg:2154"
EXTENSION="tif"
FILENAME="COG"
USE_GDALWARP=0
REMOVE_TMP_FILES=0
THREADS=1
RESAMPLING="CUBIC"
COMPRESSION="LZW"
PREDICTOR="NO"

# Message help
usage(){
>&2 cat << EOF
USAGE  : $0 --input INPUT_DIR --output OUTPUT_DIR --projection epsg:2154 --extension tif --filename COG_filename --warp
    or : $0 --i INPUT_DIR --o OUTPUT_DIR --p epsg:2154 --e tif --f COG_filename --w 
    or : $0 -i INPUT_DIR -o OUTPUT_DIR -p epsg:2154 -e tif -f COG_filename -w 
Parameters details :
Needed
   [ -i | --input       (input directory)   ]
   [ -o | --output      (output directory)  ]
Optional
   [ -p | --projection  (projection       -> default "epsg:2154") ] 
   [ -e | --extension   (raster extension -> default "tif")       ]
   [ -f | --filename    (output filename  -> default "COG")       ]
   [ -w | --warp        (use of gdalwarp  -> default without)     ]
   [ -r | --remove      (remove tmp files -> default without)     ]
   [ -m | --multithread (use all cpus     -> default without)     ]
   [ -s | --resampling  (resampling       -> default "NEAREST")   ]
   [ -c | --compression (compression      -> default "LZW")       ]
   [ -d | --predictor   (predictor        -> default "NO")        ]
EOF
exit 1
}

# Parse arguments
PARSED_ARGUMENTS=$(getopt -o hi:o:p:e:f:wrms:c:d: --long input:,output:,help,projection:,extension:,filename:,warp,remove,multithread,resampling:,compression:,predictor: -- "$@")

eval set -- ${PARSED_ARGUMENTS}
while :
do
  case $1 in
    -h | --help)        usage               ; shift   ;;
    -i | --input)       INPUT_DIR="$2"      ; shift 2 ;;
    -o | --output)      OUTPUT_DIR="$2"     ; shift 2 ;;
    -p | --projection)  EPSG="$2"           ; shift 2 ;;
    -e | --extension)   EXTENSION="$2"      ; shift 2 ;;
    -f | --filename)    FILENAME="$2"       ; shift 2 ;;
    -w | --warp)        USE_GDALWARP=1      ; shift   ;;
    -r | --remove)      REMOVE_TMP_FILES=1  ; shift   ;;
    -m | --multithread) THREADS="all_cpus"  ; shift   ;;
    -s | --resampling)  RESAMPLING="$2"     ; shift 2 ;;
    -c | --compression) COMPRESSION="$2"    ; shift 2 ;;
    -d | --predictor)   PREDICTOR="$2"      ; shift 2 ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

# Verify parameters in arguments
if [ $# -gt 0 ]; then
    echo "ERROR : Error in parameters"
    echo
    usage
    exit 2;
fi

if [ $INPUT_DIR = None ]; then
    echo "ERROR : No input were passed."
    echo
    usage
    exit 2;
fi

if [ $OUTPUT_DIR = None ]; then
    echo "ERROR : No output were passed."
    echo
    usage
    exit 2;
fi

# Temporary folder
TEMP="tmp_$FILENAME"
WARP_FOLDER="warp"

# Info user
echo
echo Build a COG named : ${FILENAME}.${EXTENSION}

# Deletes COG if exists
rm -f $OUTPUT_DIR/$FILENAME.$EXTENSION

# Creates temporary folder
mkdir $OUTPUT_DIR/$TEMP -p

# Preparation of tif with gdalwarp if necessary
if [ $USE_GDALWARP = 1 ]; then
  echo Step 0/3 : Prepare ${EXTENSION} with gdalwarp
  # Create subtree
  NEW_INPUT_DIR=$OUTPUT_DIR/$TEMP/$WARP_FOLDER
  mkdir $NEW_INPUT_DIR -p
  # Use gdalwarp
  for filepath in $INPUT_DIR/*.$EXTENSION ; do
        filename=$(basename -- "$filepath")
        gdalwarp $INPUT_DIR/$filename $NEW_INPUT_DIR/$filename
    done
  # Update input directory
  INPUT_DIR=$NEW_INPUT_DIR
fi

# List of tif
echo Step 1/3 : Create list of $EXTENSION
ls -d $INPUT_DIR/*.$EXTENSION > $OUTPUT_DIR/$TEMP/$FILENAME.txt

if [ ! -s "$OUTPUT_DIR/$TEMP/$FILENAME.txt" ]; then
    echo "File is empty."
    exit 2 
else
    echo "File is not empty."
fi

# VRT
echo Step 2/3 : Build VRT with gdalbuildvrt
echo gdalbuildvrt -input_file_list $OUTPUT_DIR/$TEMP/$FILENAME.txt $OUTPUT_DIR/$TEMP/$FILENAME.vrt
gdalbuildvrt -input_file_list $OUTPUT_DIR/$TEMP/$FILENAME.txt $OUTPUT_DIR/$TEMP/$FILENAME.vrt

# COG
echo Step 3/3 : Build COG with gdal_translate
# ARGS :
# BIGTIFF=[YES/NO/IF_NEEDED/IF_SAFER] : YES forces BigTIFF instead of classic TIFF because image will be larger than 4GB.
# COMPRESS=[NONE/LZW/JPEG/DEFLATE/ZSTD/WEBP/LERC/LERC_DEFLATE/LERC_ZSTD/LZMA] : LZW/DEFLATE/ZSTD compressions can be used with the PREDICTOR creation option. ZSTD compress more.
# PREDICTOR=[YES/NO/STANDARD/FLOATING_POINT] : YES => standard predictor=2 (use if integer data type) instead of predictor=3 (use if floating point data type but less efficient here)
echo gdal_translate \
--config GDAL_DISABLE_READDIR_ON_OPEN TRUE \
-co BIGTIFF=YES \
-co RESAMPLING=$RESAMPLING \
-co COMPRESS=$COMPRESSION \
-co PREDICTOR=$PREDICTOR \
-co NUM_THREADS=$THREADS \
-a_srs $EPSG \
-of COG \
$OUTPUT_DIR/$TEMP/$FILENAME.vrt \
$OUTPUT_DIR/$FILENAME.$EXTENSION

gdal_translate \
--config GDAL_DISABLE_READDIR_ON_OPEN TRUE \
-co BIGTIFF=YES \
-co RESAMPLING=$RESAMPLING \
-co COMPRESS=$COMPRESSION \
-co PREDICTOR=$PREDICTOR \
-co NUM_THREADS=$THREADS \
-a_srs $EPSG \
-of COG \
$OUTPUT_DIR/$TEMP/$FILENAME.vrt \
$OUTPUT_DIR/$FILENAME.$EXTENSION

# Deletes contents of temporary folder
if [ $REMOVE_TMP_FILES = 1 ]; then
  echo Delete tmp files 
  rm -f $OUTPUT_DIR/$TEMP/$FILENAME.txt
  rm -f $OUTPUT_DIR/$TEMP/$FILENAME.vrt
  if [ $USE_GDALWARP = 1 ]; then
    rm -f $OUTPUT_DIR/$TEMP/$WARP_FOLDER/*.$EXTENSION
  fi
fi

echo END.