#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

cd /home/mariana/ && mkdir .certs && cd .certs
openssl genrsa -out mariana.key 2048
openssl req -new -key mariana.key -out mariana.csr -subj "/CN=mariana/O=gurus"

sleep 1

sudo openssl x509 -req -in mariana.csr \
-CA /etc/kubernetes/pki/ca.crt \
-CAkey /etc/kubernetes/pki/ca.key \
-CAcreateserial \
-out mariana.crt -days 365

echo "Certificate Created"
sleep 1

kubectl config set-credentials mariana --client-certificate=/home/mariana/.certs/mariana.crt \
--client-key=/home/mariana/.certs/mariana.key

kubectl config set-context mariana-context --cluster=kubernetes --user=mariana

sudo mkdir /home/mariana/.kube
sudo cp ~/.kube/config /home/mariana/.kube/config
sed -i '/^contexts:/,$d' /home/mariana/.kube/config

cat <<EOF | sudo tee -a /home/mariana/.kube/config
contexts:
- context:
    cluster: kubernetes
    user: mariana
  name: mariana-context
current-context: mariana-context
kind: Config
preferences: {}
users:
- name: mariana
  user:
    client-certificate: /home/mariana/.certs/mariana.crt
    client-key: /home/mariana/.certs/mariana.key
EOF


sudo chown -R ivan: /home/mariana/

echo "User mariana Configured"
sleep 1


