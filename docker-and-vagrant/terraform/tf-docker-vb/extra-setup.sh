#!/bin/bash

sudo dnf install -y git

sudo firewall-cmd --add-port=8080/tcp --permanent

sudo firewall-cmd --add-masquerade --permanent

sudo firewall-cmd --reload

cd /home/vagrant

if [ ! -d "bgapp" ]; then
	git clone https://github.com/shekeriev/bgapp
fi

cd bgapp

if [ -f "docker-compose.yaml" ]; then
	docker compose up --detach
fi

