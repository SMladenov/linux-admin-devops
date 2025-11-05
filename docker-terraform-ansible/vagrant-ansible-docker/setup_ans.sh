#!/bin/bash

echo '192.168.100.101 docker.homework docker' | sudo tee -a /etc/hosts

sudo dnf install -y epel-release

sudo dnf install -y ansible-core

ansible-galaxy collection install ansible.posix

ssh-keyscan -H 192.168.100.101 >> ~/.ssh/known_hosts
ssh-keyscan -H docker >> ~/.ssh/known_hosts

cd ~ && ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""

sudo dnf install sshpass -y

sshpass -p 'vagrant' ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.100.101

sudo dnf install git -y

#sudo mkdir /bgapp && sudo chmod -R 777 /bgapp && cd /bgapp && git clone https://github.com/shekeriev/bgapp






