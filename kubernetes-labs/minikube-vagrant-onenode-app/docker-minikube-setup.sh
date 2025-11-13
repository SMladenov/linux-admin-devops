#!/bin/bash

echo "* Add hosts ..."
echo "192.168.99.100 kub1.lab1 kub1" >> /etc/hosts

echo "* Add Docker repository ..."
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

echo "* Install Docker ..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "* Enable and start Docker ..."
systemctl enable docker
systemctl start docker

echo "* Create user strahil ..."
useradd -m -G wheel,docker strahil
echo "strahil:123" | chpasswd

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

echo "* Firewall - open port 8080 30000..."
firewall-cmd --add-port=30000/tcp --permanent
firewall-cmd --add-port=32000/tcp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sleep 2
sudo install minikube-linux-amd64 /usr/local/bin/minikube
export PATH=$PATH:/usr/local/bin

systemctl restart docker

#Please run with a user
#minikube start --driver=docker
#minikube status

#We will try to start it directly via the provisioning
sudo -u strahil /usr/local/bin/minikube start --driver=docker





