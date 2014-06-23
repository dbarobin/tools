#!/bin/sh
#
#scripts by robin  2013-11-11
#
#added user to install oracle database software
#
#
route -n|grep UG  >/dev/null 2>&1
if  [ $? -eq 0 ];then 
 ip=$(ifconfig `route   -n|grep  UG|awk '{print $8}'`|grep "inet addr"|cut -d ":" -f2|awk '{print $1}')
 sed  "/$ip/d"  -i /etc/hosts
 hname=$1
 echo  "---------------------set hostname starting---------------------------------"
 if [ "$hname" != "" ];then
   echo "$ip   $hname.uplooking.com $hname" >>/etc/hosts
   hostname $hname.uplooking.com
 else
   echo Please enter hostname .
   echo such as server
 fi
  echo  "ip&&hostname : `tail -1  /etc/hosts`"
  echo  "---------------------set hostname successefull-----------------------------"
else
 echo  "please set default route on your system ."
 echo  "such command as :  route  add default gw <your ip addr > [dev <linkname>]" 
fi
