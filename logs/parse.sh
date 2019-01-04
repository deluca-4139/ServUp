#!/bin/bash
#This script goes through each log folder and parses the logs by month to create a new file
#that compresses the data from each day of logs into one line. This line holds a percentage
#(i.e. that the server was up for X% of the time that day). This file can then be used by a 
#different script to create graphs of this data. 
#This script DOES NOT rotate the logs. See rotate.sh for this functionality. 

testmonths=(January February March April May June July August September October November December)
year=`date | grep -o "20[0-9][0-9]"`
testmonth=`date | grep -o " [A-Z][a-z][a-z] " | grep -o "[A-Z][a-z][a-z]"`

# Actual parsing function. Creates a list of all months that have logs,
# then iterates through that list and parses all logs from each month.
function parse {
	ls | grep "${1}_.*_${2}_log" > month_list
	while read l; do
		let UP=0
		let TOTAL=0
		while read f; do
			echo $f | grep -q "UP"
			if [ $? -eq 0 ]; then
				let UP++
			fi
			let TOTAL++					
		done < $l
		DAY=$(echo $l | grep -o "_[0-9][0-9]_" | grep -o "[0-9][0-9]")
		PERCENT=$(echo "scale=4; $UP/$TOTAL" | bc -l)
		echo "$1 $DAY ~ uptime: $PERCENT" >> ${1}_${2}_parsed-uptime
	done < month_list
	rm month_list
}

# This is to check if we're running this script at the first of the year so
# we can do the parsing on last year's data. 
if [ "$testmonth" = "Jan" ]; then
	let year--
fi

# Remove the current month from the months to be parsed so that we don't parse incomplete data.
months=()
current_month=`date "+%B"`
for item in "${testmonths[@]}"; do
	[ "$item" != "$current_month" ] && months+=($item)
done

# Main function
for folder in */; do
	cd $folder
	for month in ${months[*]}; do
		ls | grep -q "${month}_.*_log"
		if [ $? -eq 0 ]; then
			parse $month $year
		fi
	done
	cd ..
done
