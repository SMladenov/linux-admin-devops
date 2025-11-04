#!/bin/bash

curl --cert <cert path> \
     --key <key path> \
	 -k -v \
     -X GET "<Full URL>" \
     -H 'Accept: application/json' \
     -H 'Key: Value' \
     -H 'Key: Value' \
     -d ""


# --noproxy '*' # Ignore proxy settings (useful for internal hosts)
# -i #Include response headers in output
# -v -w "\nHTTP_CODE:%{http_code}" # Print HTTP status code after response


