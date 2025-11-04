#!/bin/bash

ip=$1

if [ $# -ne 1 ]; then
echo -e "Please use: $0 X.X.X.0"
exit 1
fi

#Check the 4 octets in general
if ! [[ "$1" =~ ^([0-9]{1,3}\.){3}0$ ]]; then
echo -e "Please use: $0 X.X.X.0"
exit 1
fi

#Check each octet
octet1=$(echo -e "$1" | awk -F '.' '{print $1}')
octet2=$(echo -e "$1" | awk -F '.' '{print $2}')
octet3=$(echo -e "$1" | awk -F '.' '{print $3}')

if ! [[ "$octet1" -eq 10 || "$octet1" -eq 172 || "$octet1" -eq 192 ]]; then
echo -e "$octet1 is not valid private octet"
exit 1
fi

if [[ "$octet1" -eq 10 ]]; then
	if ! [[ "$octet2" -ge 0 && "$octet2" -le 255 ]]; then
	echo -e "$octet2 is not valid"
	exit 1
	fi
fi

if [[ "$octet1" -eq 172 ]]; then
        if ! [[ "$octet2" -ge 16 && "$octet2" -le 31 ]]; then
        echo -e "$octet2 is not valid"
        exit 1
        fi
fi

if [[ "$octet1" -eq 192 && "$octet2" -ne 168 ]]; then
	echo -e "$octet2 is not valid"
	exit 1
fi

if ! [[ "$octet3" -ge 0 && "$octet3" -le 255 ]]; then
echo -e "$octet3 is not valid"
exit 1
fi

#Starting the Scan
echo -e "Starting Scan for $1/24"

timeStart=$(date +%s)
counterAliveHosts=0

for i in {1..244}; do
	targetIP="$octet1.$octet2.$octet3.$i"
	result=$(ping -c 1 -w 1 $targetIP | grep -ie '.*bytes from.*')

	if ! [ -z "$result" ]; then
		counterAliveHosts=$((counterAliveHosts + 1))
		echo -e "Ping Reply from $targetIP\n$result"
		echo "********************"
	fi
done

timeEnd=$(date +%s)

timeElapsed=$((timeEnd - timeStart))

echo -e "\nScan finish for $1 in $timeElapsed seconds and found $counterAliveHosts alive hosts"









