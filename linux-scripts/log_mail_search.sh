#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo -e "Please run $0 as root with sudo"
	exit 1
fi

if [[ "$#" -ne 1 ]]; then
	echo -e "Please use: $0 <mail_address>"
	exit 1
fi

#Validating e-mail address
if ! [[ "$1" =~ ^[a-zA-Z0-9]{1,}(\.[a-zA-Z0-9]{1,})*\@[a-zA-Z0-9]{1,}([\.\-][a-zA-Z0-9]{1,})?\.[a-zA-Z]{2,10}$ ]]; then
	echo -e "Invalid e-mail address"
	exit 1
fi

mail=$1

echo -e "Starting scan for today $(date +%d-%m-%y) for $mail\n"
sleep 3

#Escape all dots
escaped_mail="${mail//./\\.}"
#Escape all @
escaped_mail="${escaped_mail//@/\\@}"
#Escape all -
escaped_mail="${escaped_mail//-/\\-}"

grep -ie "$escaped_mail" /var/log/mail.log

#Asking if we would like to continue the search
echo ""
read -p 'Do you want a scan for previous days? : ' yesOrNo

if [[ "$yesOrNo" =~ ^([Nn][Oo])$ ]]; then
	echo "Ok, exiting"
	exit 1
fi

if ! [[ "$yesOrNo" =~ ^([Yy][Ee][Ss])$ ]]; then
	echo "Invalid Input, exiting"
	exit 1
fi


#Asking for how many more days we want the search
read -p 'For how many days prior today (Max is 30)? : ' days

if ! [[ "$days" =~ ^([1-9]|[12][0-9]|30)$  ]]; then
	echo -e "Invalid number of days - Must be between 1 and 30"
	exit 1
fi

echo "Continuing the search 2"

#Searching for previous logs excluding today logs
find /var/log/ -maxdepth 1 -type f -iname 'mail.log*' ! -name 'mail.log' -mtime -"$days" \
| while IFS= read -r file; do
	logDate=$(echo $file | cut -d '.' -f 2 | cut -d '-' -f 2)
	logDate=$((logDate - 1))
	echo -e "\n\n"
	echo -e "Showing mails for date: $logDate\n"
	sleep 3

	zgrep -ie "$escaped_mail" "$file"
done











