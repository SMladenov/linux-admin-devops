#!/bin/bash

read -p "How many runs: " runs

if ! [[ "$runs" -ge 1 && "$runs" -le 100 ]]; then
	echo "runs must be between 1 and 100"
	exit 1
fi

read -p "Enter IPv4: " ip

read -p "Enter port: " port


#Test the connection for timeout and connection refused
check=$(timeout 10 telnet $ip $port < /dev/null 2>&1 | grep -i connected)

if [ -z "$check" ]; then
	echo "Connection not successful"
	exit 1
else
	echo "Connection successful, continuing"
	sleep 2
fi

for i in $(seq 1 "$runs") ; do

time timeout 2 telnet $ip $port < /dev/null 2>&1 | grep -iE 'real|user'
echo -e "Run $i\n" 
sleep 2

done


