# deploy on registery with version
REGISTRY=docker-registry.ign.fr
PROJECT_NAME=lidar_hd/cog
VERSION=`cat ../VERSION.md`

docker login docker-registry.ign.fr -u svc_lidarhd
docker tag $PROJECT_NAME:$VERSION $REGISTRY/$PROJECT_NAME:$VERSION
docker push $REGISTRY/$PROJECT_NAME:$VERSION
