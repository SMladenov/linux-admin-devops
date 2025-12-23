#!/bin/bash


cat <<EOF | sudo tee -a /etc/hosts
192.168.100.101 node1
192.168.100.102 node2
192.168.100.103 node3
192.168.100.104 nfs
EOF


