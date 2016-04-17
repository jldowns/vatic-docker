# Settings
ID=currentvideo3
ANNOTATEDFRAMEPATH=/root/vatic/data/frames_in
TURKOPS="--offline --title HelloTurk!"
LABELS="car bike skateboard"

# Start database and server
/root/vatic/startup.sh

# Set up folders
mkdir -p $ANNOTATEDFRAMEPATH
cd /root/vatic

# start database
sudo /etc/init.d/mysql start

# load frames and publish. This will print out access URLs.
turkic load $ID $ANNOTATEDFRAMEPATH $LABELS $TURKOPS
turkic publish --offline
