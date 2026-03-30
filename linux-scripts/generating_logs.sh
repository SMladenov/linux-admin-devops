#!/bin/bash

if [ $# -ne 1 ]; then
	echo -e "Usage: $0 <days(5-28)>"
	exit 1
fi

if ! [[ $1 -ge 5 && $1 -le 28 ]]; then
	echo -e "days must be between 5 and 28"
	exit 1
fi

username=$(whoami)
directory_path="/home/$username/logs/"


echo -e "Ok! Generating logs for $1 days this month in $directory_path"
sleep 2

month=$(date +%m)
year=$(date +%Y)

if ! [ -d "$directory_path" ]; then
	mkdir "$directory_path"
	if [ $? -eq 0 ]; then
		echo "Directory $directory_path created."
		sleep 2
	else
		echo "Cannot create $directory_path Please check!"
		exit 1
	fi
fi

#Check if we can write in the directory
example_filename="log_example_12345_$month".log
touch "$directory_path""$example_filename"
if [ $? -eq 0 ]; then
	echo "Permissions for writing logs ok."
	rm "$directory_path""$example_filename"
        sleep 2
else
	echo "Cannot write logs. Please check!"
	exit 1
fi


#Starting generating the logs

for day in $(seq -w 1 "$1"); do

	day=$(printf "%02d" "$day")

	filename=log_"$year"_"$month"_"$day".log

	if [ -f "$directory_path""$filename" ]; then
		rm "$directory_path""$filename"
	fi

	#Generating data for the logs
	for entry in $(seq -w 1 3); do
		timestamp=$(date +"%H:%M:%S")
		echo -e "$year $month $day $timestamp -> entry number $entry" >> "$directory_path""$filename"
		sleep 1
	done	
	
	touch -a -m -t "$year""$month""$day"1212 "$directory_path""$filename"	
	echo -e "log $directory_path$filename generated."
done


