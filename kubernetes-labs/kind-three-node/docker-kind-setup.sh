#!/bin/bash

echo "* Add hosts ..."
echo "192.168.99.100 kub3.lab1 kub3" >> /etc/hosts

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

echo "* Firewall - open port 8080 30001..."
firewall-cmd --add-port=30001/tcp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "* Install KIND ..."
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64"
chmod +x ./kind
mv ./kind /usr/local/bin/kind

systemctl restart docker

echo "* Create a 3-node KIND cluster ..."

cat <<EOF | sudo tee -a /home/strahil/kind_cluster.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

chmod 777 /home/strahil/kind_cluster.yaml

sudo -u strahil /usr/local/bin/kind create cluster --name three-node-kind \
--config /home/strahil/kind_cluster.yaml && sleep 10


#We will try to start it directly via the provisioning
sudo cp /home/vagrant/manifests/* /home/strahil/.


sudo -u strahil /usr/local/bin/kubectl apply -f /home/strahil/consumer-deployment.yml
sudo -u strahil /usr/local/bin/kubectl apply -f /home/strahil/consumer-svc.yml

nodeIP=$(sudo -u strahil /usr/local/bin/kubectl get nodes -o wide | awk 'NR==2 {print $6}')

echo -e "When logged, please test:\ncurl http://$nodeIP:30001 "






