# Continuous Integration Script:
# - builds Dockerfile
# - boots server and makes sure it's reachable from the outside

#################
##   Testing   ##
#################

### Teardown
function teardown {
    echo "Shutting down container."
    docker stop $JOB
    exit 0
}

### There should be at least one video in the video_in directory, so that
### new users can quickly run the example scripts.
if ls ./data/videos_in/*.mp4 1> /dev/null 2>&1; then
    echo "Example video found. Continuing."
else
    echo 'There must be at least one video in the ./data/videos_in directory when commiting to the master branch.'
    exit 1
fi

### Check that Dockerfile builds
docker build --no-cache -t jldowns/vatic-docker:test-build .

echo "Build passes."

### Ensure webserver starts up
echo "Starting server.."
JOB=$(\
docker run -ditP -v "$PWD/data":/root/vatic/data \
                 -v "$PWD/annotation_scripts":/root/vatic/ascripts \
                 jldowns/vatic-docker:test-build /bin/bash -C /root/vatic/start_and_block.sh \
    )
PORT=$(docker port $JOB 80 | awk -F: '{ print $2 }')

if [ $1 = "--native" ]; then
    DHOSTIP=localhost
else
    DHOSTIP=$(docker-machine ip default)
fi




echo "Checking webserver at $DHOSTIP:$PORT"

echo "Waiting for server to boot..."
# check 10 times, give 10 seconds between tries, for a total of 100 seconds
# for the server to boot.
for i in `seq 1 10`;
do
    if wget --spider -q "$DHOSTIP:$PORT" > /dev/null; then
        echo "Website Found"
        teardown
    else
        echo "Server not found. Retrying in 10 seconds..."
    fi
    sleep 10
done

echo "Server not found after 10 tries. Test fails. Shutting down image."
docker stop $JOB
exit 1
