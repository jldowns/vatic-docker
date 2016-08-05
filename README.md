# vatic-docker [![Build Status](https://travis-ci.org/npsvisionlab/vatic-docker.svg?branch=master)](https://travis-ci.org/npsvisionlab/vatic-docker)

Dockerfile and configuration files for using VATIC in a Docker container. Uses the VATIC software located at https://github.com/cvondrick/vatic

Right now everything runs in the same container. The parsed video frames reside on a volume on the host and therefore persist between runs. The annotations are put in the file 'output.xml' in the data directory. 

## Running:
Run the vatic_up script to start the docker container.  vatic_up.sh for linux and OSX and vatic_up.bat for windows.  

The last thing the script does is print out a URL that you can access that lists your published videos. That is a URL that is accessible from your host machine. Point your browser there and annotate away! You can even set up your machine to forward incoming traffic at the Docker container for collaborative annotations. Note that this is still "offline mode" since you're not using Amazon's services.
When you select one of the video links, it will open a page to allow labeling of the video.  The label objects for the objects you can label appear on the right side of the video.  You define what labels these are by putting them in a file called labels.txt in the data directory.  The labels are space delimited and all on one line.  After you are done labeling be sure and save your work or it will be lost!!!
After you annotate your videos, you can just hit the button "Output Labels" to save your work.  This will have your annotations in labelme format in the file "output.xml" in the data directory.  It will also save a copy of the database in the data directory so when you start up another docker session you can continue where you left off.

### To extract video:
Store your videos in `./data/videos_in`. The extracted frames will be sent to `./data/frames_in`. The example annotation script automatically runs the extraction script, so to after placing your video in the right spot you can skip to the next step. Note that after extraction the video is moved to `./data/videos_out` so that the system doesn't try to extract it again.

