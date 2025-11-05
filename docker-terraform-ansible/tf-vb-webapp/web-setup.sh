#!/bin/bash

#Install software
sudo dnf upgrade -y && sudo dnf update -y && sudo dnf install -y httpd && sudo dnf install -y php php-mysqlnd git

#Enable httpd
sudo systemctl enable --now httpd

#Firewalld
sudo firewall-cmd --add-masquerade && sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload

#SELinux
setsebool -P httpd_can_network_connect=1

#Pull the code
cd ~ && git clone https://github.com/shekeriev/bgapp && sleep 1
sudo rm -f /var/www/html/index.html
sudo cp ~/bgapp/web/* /var/www/html/
sudo systemctl restart httpd

#Set up the IP's
ip=$(nmcli device show enp0s8 | grep -ie 'ip4\.address.*' | awk '{print $NF}' | cut -d '/' -f 1)

echo "$ip web" | sudo tee -a /etc/hosts

IFS='.' read -r a b c d <<< "$ip"

echo -e "$a.$b.$c.$((d+1)) db" | sudo tee -a /etc/hosts


