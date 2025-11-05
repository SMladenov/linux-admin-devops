#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.homework web" >> /etc/hosts
echo "192.168.89.101 db.homework db" >> /etc/hosts

echo "* Install Software ..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y apache2 php php-mysqlnd git

echo "* Start HTTP ..."
sudo systemctl enable --now apache2

#echo "* Firewall - open port 80 ..."
#firewall-cmd --add-port=80/tcp --permanent
#firewall-cmd --reload

cd ~ && git clone https://github.com/shekeriev/bgapp && sleep 1
sudo rm -f /var/www/html/index.html
sudo cp bgapp/web/* /var/www/html/

sudo mkdir -p /var/www/html/db
sudo cp bgapp/db/* /var/www/html/db/.
sudo chmod 777 /var/www/html/db/*

echo "* Copy web site files to /var/www/html/ ..."
sudo rm -f /var/www/html/index.html
#sudo cp /vagrant/* /var/www/html

sudo systemctl restart apache2

#echo "* Allow HTTPD to make netork connections ..."
#setsebool -P httpd_can_network_connect=1
