#!/bin/bash

ANNOTATION_SCRIPT=example.sh

JOB=$(\
docker run -ditP -v "$PWD/data":/root/vatic/data \
                 -v "$PWD/annotation_scripts":/root/vatic/ascripts \
                 npsvisionlab/vatic-docker /bin/bash -C /root/vatic/ascripts/$ANNOTATION_SCRIPT \
    )

PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')
DHOSTIP=$(docker-machine ip default)

echo "Point brower to http://$DHOSTIP:$PORT/directory"
docker attach $JOB
