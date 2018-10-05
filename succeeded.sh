#!/bin/bash

SERVER=$1
PORT=$2
MONTH=`date "+%B"`
DAY=`date "+%A"`
DATE=`date "+%d"`
YEAR=`date "+%Y"`
HOUR=`date "+%I"`
MIN=`date "+%M"`
SEC=`date "+%S"`
AMPM=`date "+%p"`

if [ ! -d /servup/logs/$SERVER ] 
then
	mkdir /servup/logs/$SERVER
fi

echo -e "$SERVER (Port ${PORT}) is UP as of ${HOUR}:${MIN}:${SEC} ${AMPM}, $DAY $MONTH $DATE $YEAR" >> /servup/logs/${SERVER}/${MONTH}_${DATE}_${YEAR}_log
