#/!bin/bash

#Install software
sudo dnf upgrade -y && sudo dnf update -y && sudo dnf install -y mariadb mariadb-server git 

#Firewalld
sudo firewall-cmd --add-port=3306/tcp --permanent
sudo firewall-cmd --reload

#Pull the code
cd ~ && git clone https://github.com/shekeriev/bgapp && sleep 5 && sudo cp ~/bgapp/db/* /home/vagrant/. && sudo systemctl enable --now mariadb

#Set up the IP's
ip=$(nmcli device show enp0s8 | grep -ie 'ip4\.address.*' | awk '{print $NF}' | cut -d '/' -f 1)

echo "$ip db" | sudo tee -a /etc/hosts

IFS='.' read -r a b c d <<< "$ip"

echo -e "$a.$b.$c.$((d-1)) web" | sudo tee -a /etc/hosts

#Create and load the database ..."
sudo mysql -u root < /home/vagrant/db_setup.sql && sudo systemctl restart mariadb


