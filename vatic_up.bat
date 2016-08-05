@echo off
@setlocal
REM MUST use //c notation for drive letter!!
set MYHOME=//c/Users/tomb/Documents/nps/docker/vatic_docker
set ANNOTATION_SCRIPT=example.sh
if not exist "data\tmp" mkdir data\tmp

REM docker-machine env
for /f %%i in ('docker run -ditP -v %MYHOME%/data:/root/vatic/data npsvisionlab/vatic-docker /bin/bash -C /root/vatic/%ANNOTATION_SCRIPT%') do set JOB=%%i
for /f %%i in ('docker port %JOB% 80') do set PORT=%%i
set PORT=%PORT:~8%
for /f %%i in ('docker-machine ip default') do set DHOSTIP=%%i
echo "Point browser to : http://%DHOSTIP%:%PORT%/directory"
docker attach %JOB%
