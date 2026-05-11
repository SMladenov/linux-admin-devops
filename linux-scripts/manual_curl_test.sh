#!/bin/bash

curl --cert <cert path> \
     --key <key path> \
	 -k -v \
     -X GET "<Full URL>" \
     -H 'Accept: application/json' \
     -H 'Key: Value' \
     -H 'Key: Value' \
     -d ""


# --noproxy '*' #Ignore proxy settings (useful for internal hosts)
# -i #Include response headers in output (server name, cookies, date of the document, HTTP version, etc..)
# -v -w "\nHTTP_CODE:%{http_code}" #Print HTTP status code after response
# --connect-timeout 5 --max-time 10 #1st is only connection phase, 2nd is entire request lifecycle
# -I #HEAD request (headers only, does not download response body)


