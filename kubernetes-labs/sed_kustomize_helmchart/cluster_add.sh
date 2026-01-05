#!/bin/bash


#kubeadm init --kubernetes-version=$(kubeadm version --output=short) \
#--apiserver-advertise-address=192.168.100.101 \
#--pod-network-cidr 10.244.0.0/16 \
#--token abcdef.0123456789abcdef

#If with antrea Network or Calico Network
kubeadm init --kubernetes-version=$(kubeadm version --output=short) \
--apiserver-advertise-address=192.168.100.101 \
--pod-network-cidr 172.16.0.0/16 \
--token abcdef.0123456789abcdef

sleep 2

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Generate the join command and write it to a file
kubeadm token create --print-join-command > /vagrant/join.sh
chmod +x /vagrant/join.sh

sleep 2


#Install Network

#flannel
#kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

#If delete is needed
#kubectl delete -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml --ignore-not-found

#If newer version is needed
#kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.25.5/Documentation/kube-flannel.yml

#  wget -q https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml -O /tmp/kube-flannel.yaml
#  sed -i '/--kube-subnet-mgr/ a CHANGEME' /tmp/kube-flannel.yaml
#  sed -i "s/CHANGEME/        - --iface=$(ip a | grep 192.168.99.101 | tr -s ' ' | cut -d ' ' -f 8)/" /tmp/kube-flannel.yaml 
#  kubectl apply -f /tmp/kube-flannel.yaml


#calico
#echo "* Installing Pod Network plugin (Calico) ..."
#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.1/manifests/operator-crds.yaml
#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.1/manifests/tigera-operator.yaml
#wget -q https://raw.githubusercontent.com/projectcalico/calico/v3.31.1/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
#sed -i 's/192.168.0.0/10.244.0.0/g' /tmp/custom-resources.yaml
#kubectl create -f /tmp/custom-resources.yaml

#antrea
echo "* Installing Pod Network plugin (Antrea) ..."
kubectl apply -f https://raw.githubusercontent.com/antrea-io/antrea/main/build/yamls/antrea.yml


