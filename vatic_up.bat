@echo off
@setlocal
REM MUST use //c notation for drive letter!!
set MYHOME=//c/Users/tomb/Documents/nps/docker/vatic_docker
set HOST_ADDRESS_FILE="./data/tmp/host_address.txt"
set ANNOTATION_SCRIPT=example.sh
if not exist "data\tmp" mkdir data\tmp
echo "booting..." > %HOST_ADDRESS_FILE%

REM docker-machine env
for /f %%i in ('docker run -ditP -v %MYHOME%/data:/root/vatic/data vatic-docker /bin/bash -C /root/vatic/%ANNOTATION_SCRIPT%') do set JOB=%%i
for /f %%i in ('docker port %JOB% 80') do set PORT=%%i
for /f %%i in ('docker-machine ip default') do set DHOSTIP=%%i
echo "%DHOSTIP%:%PORT%" > %HOST_ADDRESS_FILE%
docker attach %JOB%
