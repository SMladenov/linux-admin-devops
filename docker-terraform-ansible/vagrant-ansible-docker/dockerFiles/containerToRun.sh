#!/bin/bash

docker image build -t alma-nginx-image -f Dockerfile.web /home/vagrant/dockerFiles/.

sleep 3

docker container run -d --name alma-nginx-con -p 8080:80 alma-nginx-image


