#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root with sudo"
	exit 1
fi

if [ ! -d "/statistics" ]; then
	mkdir -p /statistics
	if [ $? -eq 0 ]; then
		sleep 1
		echo "Folder created at /statictics"
	else
		echo -e "Failed to create folder under /statictics\nplease check"
		exit 1
	fi
else
	#Will try to write something
	touch /statistics/some_random_file_name.txt
	if [ $? -eq 0 ]; then
		sleep 1
		echo "Permissions ok."
		rm /statistics/some_random_file_name.txt
	else
		echo "Unable to write in /statistics\nplease check"
		exit 1
	fi
fi


echo "Starting gathering statistics, will finish in 30 minutes"

total_con=0

for i in {1..180}; do
	date_now=$(date '+%Y-%m-%d %H:%M:%S')
	current_con=$(ss -tupan | grep -e '10\.2\.5\.14' | wc -l)
	total_con=$((total_con + current_con))

	#Percentage disk usage
	disk_usage=$(df -h / | awk -F ' ' '{print $5}' | grep -vi 'use' | cut -d '%' -f 1)
	
	#Total Memory
	read mem swap <<<$(free -m | awk '{print $2}' | grep -vi 'used' | xargs)
	total_mem=$((mem + swap))

	#Free Memory
	read memfree swapfree <<<$(free -m | awk '{print $4}' | grep -vi 'shared' | xargs)
	totalfree=$((memfree + swapfree))

	#Percentage CPU Usage
	cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/' | cut -d ',' -f 4 | awk '{print 100 - $1}')

	echo -e "\n\n$date_now\ncurrent_connections: $current_con\ndisk_usage: $disk_usage %\ntotal_memory: $total_mem mb\ntotal_free_memory: $totalfree mb\ncpu_usage: $cpu_usage %\n\n" >> /statistics/global.log

	#Let's make tresholds and write to warning.log if exceeded
	#We need to use calculator for the floating cpu_usage number
	#cpu_int=${cpu_usage%.*}
	#[ "$cpu_int" -ge 80 ]
	if [ "$totalfree" -le 3000 ] || [ "$(echo "$cpu_usage >= 80" | bc)" -eq 1 ] || [ "$total_con" -ge 500 ]; then
		echo -e "\n\n$date_now\ncurrent_connections: $current_con\ndisk_usage: $disk_usage %\ntotal_memory: $total_mem mb\ntotal_free_memory: $totalfree mb\ncpu_usage: $cpu_usage %\n\n" >> /statistics/warning.log
	fi
	
	sleep 10

done

avg_con=$((total_con / 180))

echo -e "Total Connections for the last 30 minutes: $total_con" >> /statistics/global.log
echo -e "Average Connections every 10 seconds: $avg_con" >> /statistics/global.log

 
