# vatic-docker
Dockerfile and configuration files for using VATIC in a docker container.

Right now Apache and MySQL hang out in the same container, and persistance is acheived by storing their state information on a volume in the host machine.
