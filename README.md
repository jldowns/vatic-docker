**Under construction. Doesn't work yet.**

# vatic-docker
Dockerfile and configuration files for using VATIC in a docker container. Uses the VATIC software located at https://github.com/cvondrick/vatic

Right now Apache and MySQL hang out in the same container.

## Running:
To annotate a video you must 1) extract the video into frames, and 2) publish the task, either locally or on Amazon Turk. This focuses on running annotations locally.

### To extract video:
Store your videos in `./data/videos_in` and run `/extract_video.sh`. The frames will be sent to ./data/frames_in

### To annotate
Before we start, let me say I'm working on making this easier. Ok.

Store your publishing script in `./annotation_scripts`. Then run `annotate.sh`. This script will open up a bash shell. Navigate to /root/vatic/ascripts and run your script. The example script uses the --offline flag and will print out the URLs that you can use to annotate.

If you use Windows or OSX you'll have to get the port mapping from Docker to access the server. I open up another Docker Quickstart Terminal and type `docker ps` to get the container ID of my process. Let's say it's `a823450b1d6e`. Then I type:

```
JOB=a823450b1d6e
PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')
DHOSTIP=$(docker-machine ip default)
echo $DHOSTIP:$PORT
```

And this will get me the URL to access the server. Now use the previous URLs from the annotation script to access your videos.


## TODO:
- [x] Connect to server from host
- [ ] Successfully annotate video and prove the process works.
- [ ] Annotate videos with only one command.
- [ ] Persistent storage via volumes
