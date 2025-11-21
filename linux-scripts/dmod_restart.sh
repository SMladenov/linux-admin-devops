#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi


pids=$(ps aux | grep -i dmod | grep -viE "$0|grep" | awk '{print $2}')


if [ ! -z "$pids" ]; then
	echo "killing processes"
	echo -e "$pids" | xargs kill -9
	sleep 3
else
	echo "no processes found"
	sleep 2
fi

echo "Starting processes"
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


