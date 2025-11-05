#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root or with sudo"
	exit 1
fi

if [[ "$#" -ne 1 ]]; then
	echo -e "Please use: $0 stop/start/status"
	exit 1
fi

if [ "$1" != "stop" ] && [ "$1" != "start" ] && [ "$1" != "status" ]; then
	echo -e "Please use: $0 stop/start/status"
	exit 1
fi

servicesStop="service1 \
service2.service \
service3.service \
service4.service \
service5.service"

servicesStart="service5.service \
service4.service \
service3.service \
service2.service \
service1"

if [ "$1" = "status" ]; then
	#for service in $servicesStart; do
	#	systemctl status $service | head -n 7 && echo && sleep 1
	#done
	echo $servicesStart | xargs systemctl status
fi

if [ "$1" = "stop" ]; then
	for service in $servicesStop; do
		systemctl stop $service
		sleep 1
		isStopped=$(systemctl status $service | grep -ie '.*active.*running')
		if [ -z "$isStopped" ]; then
			echo -e "$service Successfully Stopped"
		else
			echo -e "$service Not Stopped! Please check"
		fi
	done
fi

if [ "$1" = "start" ]; then
	for service in $servicesStart; do
		systemctl start $service
		sleep 1
		isStarted=$(systemctl status $service | grep -ie '.*active.*running')
		if [ ! -z "$isStarted" ]; then
			echo -e "$service Successfully Started"
		else
			echo -e "$service Not Started! Please check"
		fi
	done
fi


