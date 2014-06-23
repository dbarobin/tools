#!/bin/bash
#Author:Robin Wen
#Desc:Backup databases

IP=192.168.139.13
BACKUPDIR=/backup
DATE=`date +"%Y-%m-%d-%H-%m-%S"`

if [ -d $BACKUPDIR ]
then
	echo "Backup dir already exists!"
	echo "Start baakup..."	
	/usr/local/mysql/bin/mysqldump -udiscuz -pdiscuz -h $IP --database discuz > $BACKUPDIR/$DATE.sql
	sleep 2
	echo "Backup completed!"
else
	mkdir $BACKUPDIR
	echo "Start backup..."
	/usr/local/mysql/bin/mysqldump -udiscuz -pdiscuz -h $IP --database discuz > $BACKUPDIR/$DATE.sql
	sleep 2
	echo "Backup completed!"
fi
