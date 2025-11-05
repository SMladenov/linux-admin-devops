#!/bin/bash

docker container rm --force $(docker container ls -aq)
sleep 2
docker image rm --force $(docker image ls -aq)

