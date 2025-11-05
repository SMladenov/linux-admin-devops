#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.homework web" >> /etc/hosts
echo "192.168.89.101 db.homework db" >> /etc/hosts

echo "* Install Software ..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y mariadb-server mariadb-client

echo "* Start mariadb ..."
sudo systemctl enable --now mariadb.service

#echo "* Firewall - open port 3306 ..."
#firewall-cmd --add-port=3306/tcp --permanent
#firewall-cmd --reload
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

#Generate a key-pair for private and public keys so i can copy the clonned git repository as i don't have internet neither git here
#-f -> not to prompt for file location; -N "" -> not to have a passphrase
cd ~ && ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
#ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.89.100 -> It will still ask me for password

#Add the server to known hosts not to prompt
ssh-keyscan -H 192.168.89.100 >> ~/.ssh/known_hosts

#Now we need to add the key via ssh without prompting for password
sudo apt install sshpass -y
sshpass -p 'vagrant' ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.89.100

cd ~ && sudo scp vagrant@192.168.89.100:/var/www/html/db/* /vagrant/.

echo "* Create and load the database ..."
mysql -u root < /vagrant/db_setup.sql


