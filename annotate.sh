#!/bin/bash

ANNOTATION_SCRIPT=$1

JOB=$(\
docker run -ditP -v "$PWD/data":/root/vatic/data \
                 -v "$PWD/annotation_scripts":/root/vatic/ascripts \
                 jldowns/vatic-docker /bin/bash -C /root/vatic/ascripts/$ANNOTATION_SCRIPT \
    )

PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')
DHOSTIP=$(docker-machine ip default)

echo "---- Container attached at http://$DHOSTIP:$PORT/"
docker attach $JOB
