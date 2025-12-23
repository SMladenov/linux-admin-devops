#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

sudo useradd -m -s /bin/bash ivan
sudo useradd -m -s /bin/bash mariana
echo "ivan:123" | sudo chpasswd
echo "mariana:123" | sudo chpasswd

echo "Users created on OS"
sleep 2

cd /home/ivan/ && mkdir .certs && cd .certs
openssl genrsa -out ivan.key 2048
openssl req -new -key ivan.key -out ivan.csr -subj "/CN=ivan/O=gurus"

sleep 1

sudo openssl x509 -req -in ivan.csr \
-CA /etc/kubernetes/pki/ca.crt \
-CAkey /etc/kubernetes/pki/ca.key \
-CAcreateserial \
-out ivan.crt -days 365

echo "Certificate Created"
sleep 1

kubectl config set-credentials ivan --client-certificate=/home/ivan/.certs/ivan.crt \
--client-key=/home/ivan/.certs/ivan.key

kubectl config set-context ivan-context --cluster=kubernetes --user=ivan

sudo mkdir /home/ivan/.kube
sudo cp ~/.kube/config /home/ivan/.kube/config

sed -i '/^contexts:/,$d' /home/ivan/.kube/config

cat <<EOF | sudo tee -a /home/ivan/.kube/config
contexts:
- context:
    cluster: kubernetes
    user: ivan
  name: ivan-context
current-context: ivan-context
kind: Config
preferences: {}
users:
- name: ivan
  user:
    client-certificate: /home/ivan/.certs/ivan.crt
    client-key: /home/ivan/.certs/ivan.key
EOF


sudo chown -R ivan: /home/ivan/

echo "User ivan Configured"
sleep 1


