#!/bin/bash

docker run -itP -v "$PWD/data":/root/vatic/data \
                -v "$PWD/annotation_scripts":/root/vatic/ascripts \
                jldowns/vatic-docker /bin/bash
