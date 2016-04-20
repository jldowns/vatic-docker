#!/bin/bash

ANNOTATION_SCRIPT=$1
HOST_ADDRESS_FILE="./data/tmp/host_address.txt"
mkdir -p ./data/tmp
echo "booting..." > $HOST_ADDRESS_FILE

JOB=$(\
docker run -ditP -v "$PWD/data":/root/vatic/data \
                 -v "$PWD/annotation_scripts":/root/vatic/ascripts \
                 jldowns/vatic-docker /bin/bash -C /root/vatic/ascripts/$ANNOTATION_SCRIPT \
    )

PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')
DHOSTIP=$(docker-machine ip default)

echo "---- Container attached at http://$DHOSTIP:$PORT/"
echo "$DHOSTIP:$PORT" > $HOST_ADDRESS_FILE
docker attach $JOB
