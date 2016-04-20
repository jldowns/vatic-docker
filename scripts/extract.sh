#!/bin/bash

TODOVIDEOPATH=/root/vatic/data/videos_in
DONEVIDEOPATH=/root/vatic/data/videos_out
FRAMEPATH=/root/vatic/data/frames_in

mkdir -p $FRAMEPATH
mkdir -p $DONEVIDEOPATH

cd /root/vatic
for i in $( ls $TODOVIDEOPATH); do
    turkic extract $TODOVIDEOPATH/$i $FRAMEPATH --width 720 --height 480
    mv $TODOVIDEOPATH/$i $DONEVIDEOPATH/
done
