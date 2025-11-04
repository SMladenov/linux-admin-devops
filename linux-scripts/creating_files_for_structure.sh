#!/bin/bash

if [ $# -ne  1 ]; then
	echo -e "Usage: $0 <full path to directory>"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "Directory does not exist. Trying to create it."
	sleep 1
	mkdir -p "$1"
	if [ $? -eq 0 ]; then
		echo "Directory created."
	else
		exit 1
	fi
else
	echo "Directory exists. Checking permissions."
        sleep 1
	file="example_file_just_for_the_test1.txt"
        touch "$1"/"$file"
        if [ $? -eq 0 ]; then
                echo "Permissions ok."
		rm "$1"/"$file"
        else
                exit 1
        fi
fi

#Continuing with creating the files

year=$(date '+%Y')
month=$(date '+%m')

echo -e "Creating files for this year $year"
sleep 1
	
for m in $(seq -w 1 "$month"); do
	for d in $(seq -w 1 "05"); do
		filename="$1"/file_y"$year"_m"$m"_d"$d".txt
		if [ ! -f "$filename" ]; then
			touch -a -m -t "$year""$m""$d"1212 "$filename"
		fi
	done
done

echo "Done."
sleep 1

echo "Creating files for previous 4 years"
sleep 1

for ((y=$year - 1; y>=$year - 4; y--)); do
	sleep 1
	for m in $(seq -w 1 "12"); do
		for d in $(seq -w 1 "05"); do
			filename="$1"/file_y"$y"_m"$m"_d"$d".txt
			if [ ! -f "$filename" ]; then
				touch -a -m -t "$y""$m""$d"1212 "$filename"
			fi
		done
	done
	echo -e "$y done."
done


