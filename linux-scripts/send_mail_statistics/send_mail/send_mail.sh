#!/bin/bash

source "$(dirname "$0")/env.conf"

body_text=""

if [ $# -ne 1 ]; then
       body_text="$body_text_default"
else
	body_text="$1"
fi	


echo -e "=========\nStart sending e-mail: $(date +"%Y-%m-%d %H:%M:%S")" >> "$log_path"

curl --url "smtp://smtp.gmail.com:587" \
--ssl-reqd \
--user "$username:$pass" \
--mail-from "$username" \
--mail-rcpt "$recipient" \
--upload-file - >> "$log_path" 2>&1 <<EOF
From: $username
To: $recipient
Subject: SMTP test from curl

$body_text

EOF

echo -e "E-mail was sent: $(date +"%Y-%m-%d %H:%M:%S")\n=========\n" >> "$log_path"

#Test the connection
#openssl s_client -starttls smtp -connect smtp.gmail.com:587 < /dev/null

#If needed, include -v in the curl


