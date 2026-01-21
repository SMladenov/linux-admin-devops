#!/bin/bash


if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

read -p 'Enter a full path directory where to write them: ' path

if ! [ -d $path ]; then
	echo "No such directory"
	exit 1
fi

read -r -p 'Please enter private key name: ' pkeyname

if ! [[ $pkeyname =~ ^([^ ]+)$ ]]; then
	echo "No spaces in the name allowed"
	exit 1
fi

read -p 'Please enter rsa keygen bits (2048 or 4096): ' pkeybits

if ! [[ $pkeybits =~ ^(2048|4096)$ ]]; then
	echo "Invalid bits number"
	exit 1
fi

read -p 'Would you like to set a passphrase for the key? ' passphrase

if ! [[ $passphrase =~ ^([Yy][Ee][Ss]|[Nn][Oo])$ ]]; then
	echo "Invalid answer for passphrase, must be Yes or No"
	exit 1
fi


#Generate the key
if [[ $passphrase =~ ^([Yy][Ee][Ss])$ ]]; then
	openssl genpkey -algorithm RSA \
	-pkeyopt rsa_keygen_bits:$pkeybits \
	-aes-256-cbc \
	-out $path/$pkeyname.key
else
        openssl genpkey -algorithm RSA \
        -pkeyopt rsa_keygen_bits:$pkeybits \
	-out $path/$pkeyname.key
fi

#Legacy
#openssl genrsa -out $path/$pkeyname.key -aes256 $pkeybits

echo -e "\nPrivate key generated in $path/$pkeyname.key
You can verify it later with: openssl rsa -check -in $path/$pkeyname.key
"

sleep 2

read -r -p 'Please enter csr name: ' csrname

if ! [[ $csrname =~ ^([^ ]+)$ ]]; then
        echo "No spaces in the name allowed"
        exit 1
fi

openssl req -new -key $path/$pkeyname.key -out $path/$csrname.csr

sleep 2

echo -e "\nCSR generated in $path/$csrname.csr
You can verify it later with: openssl req -text -noout -verify -in $path/$csrname.csr
"

#Check if all of them match
#openssl rsa -noout -modulus -in $path/$pkeyname.key | openssl md5
#openssl req -noout -modulus -in $path/$csrname.csr | openssl md5
#openssl x509 -noout -modulus -in *.pem | openssl md5


