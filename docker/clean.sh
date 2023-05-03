# supprime toutes les images contenant ctclass
docker rmi -f `docker images | grep cog | tr -s ' ' | cut -d ' ' -f 3`
docker rmi -f `docker images -f "dangling=true" -q`

