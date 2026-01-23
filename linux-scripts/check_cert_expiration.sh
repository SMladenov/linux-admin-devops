#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

default_dirs=" 
/etc/ssl \
/etc/pki/tls \
/etc/nginx \
/etc/apache2 \
/etc/httpd "

if [ $# -ne 1 ]; then
	echo -e "Usage: $0 <full path to directory> to scan"
	sleep 3
	echo -e "We will continue default directory scan of: $default_dirs"
	sleep 3
elif [ $# -eq 1 ]; then
	if ! [ -d "$1" ]; then
		echo -e "$1 is not a directory"
		exit 1
	else
		echo -e "Starting scan of $1"
		default_dirs=$1
		sleep 3
	fi
fi

date_now=$(date +"%Y_%m_%d")
full_path_file="/tmp/cert_report_${date_now}.txt"
counter=1

for dir in $default_dirs; do
	if [ -d "$dir" ]; then
		find "$dir" -type f | while IFS= read -r file; do
			type=$(file "$file" | awk '{$1=""; sub(/^ /,""); print}')
			if [[ "$type" == "PEM certificate" ]]; then
				is_ca=$(openssl x509 -in "$file" -text -noout | grep -ie 'CA:TRUE')
				if [ -z "$is_ca" ]; then
					#Starting checking the validity for 30 days
					is_valid=$(openssl x509 -checkend $((30 * 24 * 3600)) -noout -in "$file")
					echo -e "$counter. $file -----> $is_valid\n" >> "$full_path_file"
					counter=$((counter + 1))
				fi
				
			fi	
		done
	fi

done

if [ -f $full_path_file ]; then
	echo -e "Full report available at $full_path_file"
	sleep 3
else
	echo "No Report Available, no certificates found"
fi


