# Short information about the scripts

# systemd_stop_start_status.sh
- Ran as root, gives information about status or stop/start a collection of systemd services
while returning a successful status or not

# log_mail_search.sh
- Ran as root, accepts 1 parameters, validates the parater to be an email-address, gives results from mail logs for today,
asks if we want to continue the search and for how many previous days to give the result, validating input

# manual_scan.sh
- Accepts 1 parameter, an IPv4, validating to be one of the private ranges:
10.0.0.0/8
172.16-31.0.0/12
192.168.0.0/16
- Performs a 24 CIDR search for alive hosts via ICMP, returns result/output if successful and finally outputs the total alive hosts
and total time elapsed

# manual_curl_test.sh
- Basically to test a HTTP request, while the modifications may vary

# sorting_files_by_year_month.sh
- The purpose of the script is to arrange a large amount of files located in a specific folder, saying we have 100k+ files and we cannot
open the folder, or it lags too much
- Accepting 2 parameters, full path to directory and for which year to perform the sorting, validating input, validating permissions to write
and then start the sorting, and checking not to overwrite any files if they exist at the destination folder

# creating_files_for_structure.sh
- The purpose of the script is to create files for structure to test the sorting_files_by_year_month.sh
- Accepts 1 parameter, a destination folder, where the files will be created and checking permissions
and creating 5 files for 5 days each month for the 5 previous years

 
