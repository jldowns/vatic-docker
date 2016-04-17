#!/bin/bash

docker-machine create --driver=virtualbox --virtualbox-cpu-count "2" default
docker-machine start default
eval "$(docker-machine env default)"

# docker run -itP -v "$PWD/videos":/root/vatic/videos jldowns/vatic-docker /bin/bash

JOB=$(docker run -itP -v "$PWD/data":/root/vatic/data jldowns/vatic-docker /bin/bash)
PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')
DHOSTIP=$(docker-machine ip default)

sleep 1 # wait a moment to let the server come online
open http://$DHOSTIP:$PORT/
