#/bin/bash

cpu_num=$(nproc)

#To generate load for each core "yes > /dev/null &"

log_path="/tmp/cpu_io_ram_stat.log"

load_5_min_alerts=0
load_15_min_alerts=0
idle_alerts=0
wa_alerts=0
date_now=$(date +"%Y-%m-%d %H:%M:%S")

#Gather statistics for load average every 1 minute for 18 minutes
for value in {1..18}; do
	read -r load_1 load_5 load_15 <<< $(cat /proc/loadavg | awk '{print $1, $2, $3}')

	#Converting from float to int using bc
	load_5_int=$(printf "%.0f" "$(echo "$load_5 * 100" | bc)")
	load_15_int=$(printf "%.0f" "$(echo "$load_15 * 100" | bc)")
	cpu_int=$((cpu_num * 100))
	
	#echo -e "cpu_num: $cpu_int\n5 min: $load_5_int\n15 min: $load_15_int\n"

	if [ $load_5_int -gt $cpu_int ]; then
		load_5_min_alerts=$(($load_5_min_alerts + 1))
	fi

	if [ $load_15_int -gt $cpu_int ]; then
                load_15_min_alerts=$(($load_15_min_alerts + 1))
        fi

	#Gathering idle statistics (id)
	idle_array=$(top --batch -n3 | grep "%Cpu" | awk -F',' '{print $4}' | awk '{print $1}')
	for value in $idle_array; do
		value_idle_int=$(printf "%.0f" "$value")
		if [ $value_idle_int -lt 20 ]; then
			idle_alerts=$(($idle_alerts + 1))
			break
		fi	
	done

	#Gathering I/O wait statistics (wa)
	wa_array=$(top --batch -n3 | grep "%Cpu" | awk -F',' '{print $5}' | awk '{print $1}')
	for value in $wa_array; do
		value_wa_int=$(printf "%.0f" "$value")
		if [ $value_wa_int -gt 30 ]; then
			wa_alerts=$(($wa_alerts + 1))
			break
		fi
	done

	#echo -e "\nidle_alerts: $idle_alerts\nwa_alerts: $wa_alerts\nCounter_load_15: $load_15_min_alerts\nCounter_load_5: $load_5_min_alerts\n"
	
	#Write some logging	
	date_for_log=$(date +"%Y-%m-%d %H:%M:%S")
	text_for_log=$(cat <<EOF
===
$date_for_log
1. load
load_5_min: $load_5
load_15_min: $load_15

2. idle
$idle_array

3. wa
$wa_array
===

EOF
)

	echo "$text_for_log" >> "$log_path"
	
	sleep 60
done

name=$(hostname)
current_dir="$(dirname "$0")"

#Send an e-mail notification if a threshold is exceeded
if [ $load_15_min_alerts -ge 1 ]; then
	if [ $idle_alerts -ge 1 ] || [ $wa_alerts -ge 1 ]; then
		body_text=$(cat <<EOF
$date_now
System with name: $name
System is overloaded !
load average 15 minutes alerts: $load_15_min_alerts
cpu is not idle alerts: $idle_alerts
I/O wait alerts: $wa_alerts

EOF
)
		"$current_dir/send_mail/send_mail.sh" "$body_text"
	fi
fi


