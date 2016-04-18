# vatic-docker
Dockerfile and configuration files for using VATIC in a Docker container. Uses the VATIC software located at https://github.com/cvondrick/vatic

Right now everything runs in the same container. The parsed video frames reside on a volume on the host and therefore persist between runs. The direction below also explain how to dump the annotations to the volume. The only way to access the annotations outside the container is to dump them to a shared volume (like `/root/vatic/data`.) Emergency data retrieval procedures are outlined below.

## Running:
To annotate a video you must 1) extract the video into frames, and 2) publish the task, either locally or on Amazon Turk. I'll go over running annotations locally.

### To extract video:
Store your videos in `./data/videos_in`. The extracted frames will be sent to `./data/frames_in`. The example annotation script automatically runs the extraction script, so to after placing your video in the right spot you can skip to the next step. Note that after extraction the video is moved to `./data/videos_out` so that the system doesn't try to extract it again.

If you just want to extract the frames without running an annotation script, you can run
```
docker run -v "$PWD/data":/root/vatic/data jldowns/vatic-docker /root/vatic/extract.sh
```

### To annotate
Before we start, let me say I'm working on making this easier.

Store your publishing script in `./annotation_scripts`. Run `annotate.sh <name of annotation script>`. This repository contains a script called `example.sh`, so to run it type
```
./annotate.sh example.sh
```

The example script does some things to streamline the process. It automatically calls the database/server startup script and opens a bash shell at the end. I recommend basing your annotation scripts on the example script, at least the first time.

This is where things get a little more involved. When the `annotate.sh` script runs, it also prints out the local address and port that the Docker container is bound to. Take note of this. This is the address that is forwarded to `localhost` inside the container. After publishing the videos, turkic will print out the URLs you use to access the annotation tool. For example, it might print out something that looks like:
```
http://localhost/?id=1&hitId=offline
http://localhost/?id=2&hitId=offline
http://localhost/?id=3&hitId=offline
```
Replace `localhost` with the IP:PORT that the script had printed out for you. For example, if the script reported

```
---- Container attached at http://192.168.99.100:32813/
```

you can annotate your videos at
```
http://192.168.99.100:32813/?id=1&hitId=offline
http://192.168.99.100:32813/?id=2&hitId=offline
http://192.168.99.100:32813/?id=3&hitId=offline
```

### To get your annotations out of the container

This is why the example script opens up a bash shell at the end; you have to do this step on the command line. Navigate to `/root/vatic` and type the following command

```
turkic dump currentvideo -o /root/vatic/data/output.txt
```
Where `currentvideo` is the ID from your annotation script and `ouput.txt` is the filename you want your annotations to be saved to. Look in your `./data` folder for the annotations.

## Ahh! I accidentally exited before dumping the annotation!
Find the container you just stopped by typing
```
docker ps -a
```
You can then restart and reattach the container and dump your data by typing
```
docker start $JOB
docker attach $JOB
```
where `$JOB` is the container ID. It's likely that the ID is still stored in the variable if you used the `annotate.sh` script.

## TODO:
- [x] Connect to server from host
- [x] Successfully annotate video and prove the process works.
- [ ] Start annotating videos with only one command.
- [ ] More easily dump annotation data
- [ ] Persistent storage
