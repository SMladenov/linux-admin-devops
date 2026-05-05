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

# performance_check.sh
- The purpose is to gather information about a server every 10 seconds in 30 minutes range and append to log files with timestamp
- network connections, avg network connections, disk usage, memory usage, cpu usage

# dmod_restart.sh
- restart of some processes

# test_connection_time.sh
- test connection time via telnet for max attempts 100

# gen_privatekey_csr.sh
- generates private rsa key 2048 or 4096 and csr ready for signature

# check_cert_expiration.sh
- given 1 parameter as directory, or none it will scan the default certificates directories and 
will produce report on what is expiring or not in the next 30 days

# generating_logs.sh
- script generating logs for 5 to 28 days in the current month with actual content, it's purpose is to generate logs in order to test our log rotation script

# rotate_log.sh
- script for rotating logs, accepting 2 parameters - path and days for retention, example usage:
./rotate_l.sh --path /home/vagrant/logs/ --days 11 >> /home/vagrant/logs/output.txt


