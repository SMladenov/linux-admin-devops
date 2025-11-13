#!/bin/bash

for i in {1..6} ; do 

kubectl apply -f "/home/strahil/manifests/"$i-*
if [ $? -eq 0 ]; then
	sleep 5
else
	echo -e "Error executing manifest number $i"
	exit 1
fi

done

url=$(minikube service homework-svc -n homework --url)

echo -e "Execution Completed\nPlease use curl $url to check it"


