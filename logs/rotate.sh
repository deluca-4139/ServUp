#!/bin/bash
#This script will go through each folder of logs and compile each set of monthly logs into a tar
#file. This script should be run once a month at the beginning of the month in order to keep the
#prior month's logs compressed.

month=`date "+%B" --date="yesterday"`
year=`date "+%Y" --date="yesterday"`

# Actual rotate function. Checks to see if there are actually logs in the folder
# with the given function arguments, and then tars them, moves the tar into 
# a parsed logs folder, and then deletes all the old logs. 
function rotate {
	for folder in */; do
		cd $folder
		[ ! -d parsed_logs ] && mkdir parsed_logs
		ls | grep -q "${1}.*${2}.*log"
		if [ $? -eq 0 ]; then
			find -name "${1}*${2}*log" | tar -cf ${1}_${2}_logs.tar -T -
			mv ${1}_${2}_logs.tar parsed_logs/
			rm $( find -name "${1}*${2}*log" )
		fi
		cd ..
	done
}

# If there are command line arguments, use those as months instead of using the default
# which is the prior month.
if [ $# -gt 0 ]; then
	for x in $@; do
		rotate $x $year
	done	

else
	rotate $month $year
fi
