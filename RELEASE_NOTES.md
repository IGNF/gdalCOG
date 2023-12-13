# dev
- newdev : compression, predictor and resampling now in option. Default compression is still `LZW`. Default predictor is now `NO`. Default resampling is `CUBIC`(same as in previous versions).
- newdev : set resampling to nearest (different with gdal, where : "Resampling method used for overview generation or reprojection. For paletted images, NEAREST is used by default, otherwise it is CUBIC.")

# v0.2.3
- fixbug : delete cog if already exists (conflict on gdal_translate)

# v0.2.2
- feat : rename tmp folder with specific suffix (useful when building several COG in the same folder at the same time)
- feat : option use multithreading with gdal_translate
- feat : file RELEASE_NOTES

# v0.2.1
- feat : option remove (remove temporary folders)
- refactor : long arguments
- fixbug : modification docker : add image cleaner and add an update for fix issue on git install
- feat : not overwrite .txt and .vrt anymore when launching several times on the same destination folder


# v0.2.0
- Feat : Add option gdalwarp 
