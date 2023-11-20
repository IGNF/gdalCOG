FROM osgeo/gdal:ubuntu-small-latest AS builder

RUN apt-get update && \
    apt-get install -y git

RUN git clone https://github.com/IGNF/gdalCOG.git
