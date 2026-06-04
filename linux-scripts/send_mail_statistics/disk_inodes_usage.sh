#!/bin/bash

disk_usage=$(df -hT | awk -F" " '{print $6}' | grep -vi 'use' | awk -F'%' '{print $1}')
name=$(hostname)
current_dir="$(dirname "$0")"


for value in $disk_usage; do
	if [[ $value -ge 80 ]]; then
		#Send an e-mail notification	
		body_text=$(echo -e "!!! Disk Usage $value% on machine with hostname: $name !!!")
		$current_dir/send_mail/send_mail.sh "$body_text"		
		break
	fi
done


inodes_usage=$(df -hTi | awk -F' ' '{print $6}' | grep -vi 'IUse' | cut -d '%' -f 1)

sleep 3


for value in $inodes_usage; do
	if [[ $value -ge 80 ]]; then
		#Send an e-mail notification
		body_text=$(echo -e "!!! Inodes Usage $value% on machine with hostname: $name !!!")
		$current_dir/send_mail/send_mail.sh "$body_text"
		break
	fi
done


#To check disk usage per directories
#du -xh --max-depth=1 / \
#--exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run \
#--exclude=/home/vagrant/inodes_flood \
#--exclude=/home/vagrant/inodes_flood2 \
#--exclude=/home/vagrant/inodes_flood3 \
#2>/dev/null

#-x, --one-file-system
# skip directories on different file systems


#To check Inodes usage per directories

#for dir in /* ; do echo -n "$dir -> " ; find "$dir" -xdev -type f 2>/dev/null | wc -l ; echo "" ; done


