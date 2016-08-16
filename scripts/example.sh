#!/bin/bash

# Settings
ID=currentvideo
VIDEOPATH=/root/vatic/data/videos_in
ANNOTATEDFRAMEPATH=/root/vatic/data/frames_in
TURKOPS="--offline --title HelloTurk!"
LABEL_FILE=/root/vatic/data/labels.txt
if [ -f "$LABEL_FILE" ]
then
    LABELS=`cat $LABEL_FILE`
    echo "Labels = $LABELS"
else
    echo "!!! data/labels.txt is required !!!!"
    echo "This file is a single line space seperated list of label names"
    exit 1
fi

NEWVIDEO=0
OLDVIDEO=0
if [ -d "/root/vatic/data" ]
then
    if [ -d ${VIDEOPATH} ]
    then
        if test "$(ls -A ${VIDEOPATH} 2>/dev/null)"
        then
            echo "New Videos to process."
            NEWVIDEO=1
        else
            echo "No new videos to process."
        fi
   fi 
fi
if [ -d ${ANNOTATEDFRAMEPATH} ]
then
    OLDVIDEO=1
fi
if [ ${NEWVIDEO} -eq 0 -a  ${OLDVIDEO} -eq 0 ]
then
    echo "!!!No new video or access to previous video's frames!!!"
    exit 1
fi
# Start database and server
/root/vatic/startup.sh

# Convert videos that need to be converted
/root/vatic/extract.sh

# Set up folders
mkdir -p $ANNOTATEDFRAMEPATH
cd /root/vatic

# load frames and publish. This will print out access URLs.
turkic load $ID $ANNOTATEDFRAMEPATH $LABELS $TURKOPS

mkdir -p /root/vatic/public/directory

if [ -f /root/vatic/data/db.mysql ];
then
    echo "Reading in previous database"
    mysql -u root < /root/vatic/data/db.mysql
fi

# replace the 'localhost' of the output to the host's address, and format it into
# a series of html links. Save this at the /directory page in the website.
{ turkic publish --offline |\
  tee /dev/fd/3 | sed "s|http://localhost|<a href=\.\.|" |\
                  sed "s|offline|offline> Video Segment <\/a><br>|"  > /root/vatic/public/directory/index.html; } 3>&1


# add some user interface controls
#cat $PWD/ascripts/vatic_index.html >> /root/vatic/public/index.html
cat $PWD/ascripts/myhtml.html >> /root/vatic/public/directory/index.html
cp $PWD/ascripts/myphp.php  /root/vatic/public/directory
chgrp -R www-data /root/vatic/data
chmod 775 /root/vatic/data


# open up a bash shell on the server

/bin/bash
