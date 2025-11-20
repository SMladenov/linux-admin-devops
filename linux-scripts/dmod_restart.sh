#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

echo "Killing processes"
ps aux | grep -i dmod | grep -v $0 | awk '{print $2}' | xargs kill -9
sleep 2

echo "Done, Starting them"
sleep 2

for file in /usr/local/dmod*/bin/dmodd; do
	$file
	if [ $? -eq 0 ]; then
		sleep 3
		echo -e "\nStarted $file\n"
	fi

done

echo -e "All dmod processes\n"

ps aux | grep -i dmod | grep -v grep


