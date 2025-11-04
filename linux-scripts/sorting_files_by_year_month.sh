#!/bin/bash

if [ $# -ne 2 ]; then
	echo -e "Usage: $0 <full path to directory> <year>"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "Directory does not exist."
	exit 1
fi

if [ -d "$1" ]; then
	if ! [[ "$2" =~ ^20[0-9]{2}$ ]]; then
		echo -e "$2 not valid"
	fi
fi

#Starting creating the structure of folders

year=$2
yearPath="$1"/"$year"

if [ -d "$yearPath" ]; then
        echo -e "$year Directory exists. Checking permissions."
	sleep 1
        randomName="randomDirectoryToBeCreated"
        mkdir "$yearPath"/"$randomName"
        if [ $? -eq 0 ]; then
                echo "Permissions ok."
                sleep 1
               	rmdir "$yearPath"/"$randomName"
        else
                exit 1
        fi
fi

if [ ! -d "$yearPath" ]; then
	echo -e "$year Directory does not exist. Trying to create it."
	sleep 1
	mkdir "$yearPath"
	if [ $? -eq 0 ]; then		
		echo "Permissions ok. Directory Created."
		sleep 1
	else
		exit 1
	fi
fi

#Main Year folder created, checked permissions, starting with the months

for m in $(seq -w 1 "12"); do
	fullMonthPath="$yearPath"/"$m"
	if [ ! -d "$fullMonthPath" ]; then
		mkdir "$fullMonthPath"
		echo -e "$m month directory created."
		sleep 1
	else
		file="example_file_just_for_the_test1.txt"
		touch "$fullMonthPath"/"$file"
		if [ $? -eq 0 ]; then
			echo -e "Folder for month $m exists. Permissions ok."
			rm "$fullMonthPath"/"$file"
			sleep 1
		else
			exit 1
		fi
	fi
done

#After created folders, checked permissions, time to perform the sorting
#From January to November and December separately

for m in $(seq -w 1 "12"); do
	destination="$yearPath"/"$m"
	startDate="$year-$m-01"

	#Formatting the month from string to decimal and back to string
	nextMonth=$(printf "%02d" $((10#$m + 1)))

	endDate="$year-$nextMonth-01"

#Now to do it for December
	if [ "$m" = "12" ]; then
		nextYear=$(($year + 1))
		allFiles=$(find "$1" -maxdepth 1 -type f -newermt "$year-12-01" ! -newermt "$nextYear-01-01" | wc -l)
		
		filesBefore=$(ls "$destination" | wc -l)
	        echo -e " Before(at destination): $filesBefore Files for $year-$m"
		echo -e " Starting Date: $year-12-01 -> End Date: $nextYear-01-01 -> Found Files: $allFiles"

		find "$1" -maxdepth 1 -type f -newermt "$year-12-01" ! -newermt "$nextYear-01-01" \
		| while IFS= read -r file; do

			#Now we need to check if the filename exists not to overwrite it
			fileName=$(echo $file | awk -F '/' '{print $NF}')
			if [ ! -f "$destination/$fileName" ]; then
				mv "$file" "$destination"
				if [ $? -ne 0 ]; then
                                	exit 1
				fi
                    	fi
		done
		filesAfter=$(ls "$destination" | wc -l)
		echo -e " After(at destination): $filesAfter Files for $year-12\n"
		exit 0
	fi

#All other months Jan-Nov
	allFiles=$(find "$1" -maxdepth 1 -type f -newermt "$startDate" ! -newermt "$endDate" | wc -l)
	
	filesBefore=$(ls "$destination" | wc -l)
        echo -e " Before(at destination): $filesBefore Files for $year-$m"
	echo -e " Starting Date: $startDate -> End Date: $endDate -> Found Files: $allFiles"

	find "$1" -maxdepth 1 -type f -newermt "$startDate" ! -newermt "$endDate" \
	| while IFS= read -r file; do

		#Now we need to check if the filename exists not to overwrite it
                fileName=$(echo $file | awk -F '/' '{print $NF}')
		if [ ! -f "$destination/$fileName" ]; then
			mv "$file" "$destination"
			if [ $? -ne 0 ]; then
				exit 1
			fi
		fi
	done
	filesAfter=$(ls "$destination" | wc -l)
	echo -e " After(at destination): $filesAfter Files for $year-$m\n"
	sleep 1
done


