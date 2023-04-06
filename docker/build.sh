# build lidar_hd/cog
PROJECT_NAME=lidar_hd/cog
VERSION=`cat ../VERSION.md`

docker build --network host --no-cache -t $PROJECT_NAME -f Dockerfile .
docker tag $PROJECT_NAME $PROJECT_NAME:$VERSION
