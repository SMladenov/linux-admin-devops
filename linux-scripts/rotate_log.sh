#!/bin/bash

error_message="Usage: $0 --path <path_to_logs> --days <days>"

if [ $# -ne 4 ]; then
	echo "$error_message"
	exit 1
fi


case "$1" in
--path)
	if [ ! -d "$2" ]; then
		echo "Invalid Directory $2"
		exit 1
	fi
	path="$2"
	;;
*)
	echo "$error_message"
	exit 1
	;;
esac

case "$3" in
--days)
	if ! [[ $4 -ge 5 && $4 -le 28  ]]; then
        	echo "Days must be between 5 and 28"
        	exit 1
	fi
	days=$4
	;;
*)
        echo "$error_message"
        exit 1
	;;
esac


logs_found=$(find "$path" -maxdepth 1 -type f -name '*.log')

while IFS= read -r file; do
	#Get the year, month and day
	read -r year month day <<< $(stat -c %y "$file" | awk '{print $1}' | awk -F '-' '{print $1,$2,$3}')
	
	new_file="$file.$year$month$day.gz"

	#Start rotating
	if ! [ -f "$new_file" ]; then
		gzip --stdout "$file" > "$new_file"
		if [ $? -eq 0 ]; then
			#Truncate original
			sleep 1 && : > "$file"
			echo -e "Log successfully rotated: $file ---> $new_file"
		else
			echo -e "Rotation failed for $file" >&2
		fi
	fi
done <<< "$logs_found"

#Delete logs older than "$days" days
logs_to_be_deleted=$(find "$path" -maxdepth 1 -type f -name '*.gz' -mtime +"$days")

if ! [ -z "$logs_to_be_deleted" ]; then
	while IFS= read -r file; do
		rm "$file" && sleep 1 && echo -e "Log $file has been deleted"
	done <<< "$logs_to_be_deleted"
fi


