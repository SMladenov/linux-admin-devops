#!/bin/bash




useradd -m --comment "strahil" strahil -s /bin/bash
echo "strahil:123" | chpasswd
usermod -aG sudo strahil
apt update -y && apt upgrade -y
apt install nfs-kernel-server -y
sudo nfsconf --set nfsd vers3 n
#root@nfs:/home/strahil# less /etc/nfs.conf

systemctl enable --now nfs-server
systemctl restart nfs-server
sudo systemctl mask --now rpcbind.service rpcbind.socket rpc-statd.service
#ss -4ntl #(secure socket port listing) - should be only 2049 for nfs4

mkdir -pv /data/nfs/k8sdata
chmod 777 /data/nfs/k8sdata
echo '/data/nfs/k8sdata *(rw)' | tee -a /etc/exports
echo 'Apply the export'
exportfs -rav


