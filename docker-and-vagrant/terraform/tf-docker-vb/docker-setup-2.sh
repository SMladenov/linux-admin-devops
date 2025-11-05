#!/bin/bash

sudo dnf -y update && dnf upgrade -y

sudo dnf -y install dnf-utils curl && dnf install -y epel-release

sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable --now docker

sudo usermod -aG docker vagrant

