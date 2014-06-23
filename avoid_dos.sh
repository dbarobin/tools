#!/bin/bash
#Author:Robin yWen
#Date:2013- 9- 14 11:07:25
#Func:Analyze  /var/log/httpd/access_log
while  :
do
	count=`cat /var/log/httpd/access_log | awk '{print $1}' | sort | sort  - n| uniq  - c | awk - F" " '{print  $1}'`
	ip=`cat /var/log/httpd/access_log | awk '{print $1}' | sort | sort - n| uniq  - c | awk - F" " '{print  $2}'`
	count_arr=($(echo  $count  |tr '' ' '))
	ip_arr=($(echo  $ip |tr '' ' '))

	if [ ${count_arr[$i]} -gt 9 ]
	then	
		echo "Tried  to  connect  this  machine  mostly  is:  "${ip_arr[$i]}",  count  is: "${count_arr[$i]}
		echo "Use iptables to avoid arp..."
		iptables -A INPUT -p icmp -s ${ip_arr[$i]} -j REJECT 
	fi
	sleep 3
done
