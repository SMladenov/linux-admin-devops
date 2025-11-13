#!/bin/bash

filePath="/home/strahil/manifests/homework-all.yaml"

if [ -f $filePath ]; then
	rm $filePath
fi

for i in {1..6}; do

cat "/home/strahil/manifests/"$i-* >> $filePath

echo -e '\n---\n' >> $filePath

done

echo -e "Please execute:\nkubectl apply -f $filePath"
echo -e "\nGet the url and check if working:\nminikube service homework-svc -n homework --url"


