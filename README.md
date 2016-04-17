**Under construction. Doesn't work yet.**

# vatic-docker
Dockerfile and configuration files for using VATIC in a docker container.

Right now Apache and MySQL hang out in the same container, and persistance is acheived by storing their state information on a volume in the host machine.

## Running:
The included file `start_vatic.sh` will spin up a container and point your browser at the correct port number.

## TODO:
- [ ] Successfully have Apache and MySQL running upon startup
- [x] Connect to server from host
- [ ] Persistent storage via volumes
