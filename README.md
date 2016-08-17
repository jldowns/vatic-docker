# vatic-docker [![Build Status](https://travis-ci.org/npsvisionlab/vatic-docker.svg?branch=master)](https://travis-ci.org/npsvisionlab/vatic-docker)

# vatic-docker - Packaged up Vatic video annotation tool

## What is vatic-docker

Dockerfile and configuration files for using VATIC in a Docker container. Uses the VATIC software located at https://github.com/cvondrick/vatic.  This docker container will start an apache web server that will allow you to create annotation labels from within a browser and save those annotations to an xml file.  See the VATIC github site for a description of VATIC. Currently "offline mode" is the only mode supported.


## SETUP

In the directory where you want to run the docker command create a directory called 'data'.  In that directory create a directory called 'video_in'.  In the 'video_in' directory put the video that you want to annotate.

In the 'data' directory create a text file called 'labels.txt'.  Put all the object types that you want to label on the first line seperated by spaces.  So for example, if you are going to annotate people and cars put one line in 'labels.txt' that has 'people cars'.

The 'data' directory is shared by the host and the docker container and it will put the results back into that directory.

If you are using a docker-machine, you will have to start it and run docker-machine env and configure your env to point to it.

## RUNNING 

To start the container run the following command:

    docker run -itp -v data:/root/vatic/data npsvisionlab/vatic-docker /bin/bash -C /root/vatic/example.sh

This will start the apache web server and create image frames from the video located in "video_in".  The frames will be put in "frames_in" and the video will be moved to the folder called "video_out"

Find the ip address and port number that the server is running on.  If you are using docker-machine, 'docker-machine ip default' will show you the port and 'docker-machine port JOBID 80' will output the port the server is listening on.

Open up a brower to point to http:/xxxx.xxxx.xxxx.xxxx:PORT/directory where the xxxx.xxxx.xxxx.xxxx is the ip-address and PORT is the port number.

## ANNOTATING A VIDEO

When you select one of the video links, it will open a page to allow labeling of the video.  The label objects for the objects you can label appear on the right side of the video.  These you defined by putting them in a file called labels.txt in the data directory.  The labels are space delimited and all on one line.  

After you annotate your videos, you can just hit the button "Output Labels" to save your work.  This will save your annotations in labelme format in the file "output.xml" in the data directory.  It will also save a copy of the database in the data directory so when you start up another docker session you can continue where you left off.

When you are done annotating the video just type in <ctl>c or exit to close the docker container.

