#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Desc:Batch Add user

file=userlist

if [ -f $file ]
then
    unamearr=`awk -F" " '{print $1}' userlist`
    num=`cat $file | wc -l`
    username=($(echo $unamearr |tr '' ' '|tr -s ' '))
    passarr=`awk -F" " '{print $2}' userlist`
    password=($(echo $passarr |tr '' ' '|tr -s ' '))
    groarr=`awk -F" " '{print $3}' userlist`
    group=($(echo $groarr |tr '' ' '|tr -s ' '))
    for ((j=0;j<$num;j++))
    do
	#echo ${username[$j]}
        unum=`id ${username[$j]} > /dev/null 2>&1| wc -l`
        if [ $unum -gt 0 ]
        then
  	    echo "User is already have!!!"
  	else
	    `useradd ${username[$j]} > /dev/null 2>&1`
	    #echo ${username[$j]}
  	fi
       
        #echo ${password[$j]}
	#${password[$j]}
	if [ ${password[$j]} != "" ]
	then
	   `echo ${password[$j]} | passwd --stdin ${username[$j]} > /dev/null 2>&1`
	else
	    echo "Password is null!!!"
	fi
	groupnum=`cat /etc/group | grep "*$${group[$j]}*" -E | wc -l`
	#echo ${group[$j]}
	if [ $groupnum -gt 0 ]
	then 
	    echo "Group is already have"
	else
            gro=($(echo ${group[$j]} | tr ',' ' '|tr -s ' '))
	    #echo $gro
    	    length=${#gro[@]}
	    #echo $length
            for ((i=0;i<1;i++))
	    do
	   	maingroup=${gro[$i]}
		#echo ${gro[$i]}
		#echo $maingroup
		`groupadd $maingroup > /dev/null 2>&1`
            	`usermod -g $maingroup ${username[$j]} > /dev/null 2>&1`
  	    done
	    #echo $maingroup
	    #`groupadd $maingroup`
	    #`usermod -g $maingroup ${username[$j]}`
            for((i=1;i<length;i++))
	    do
		otherg=${gro[$i]}
		#echo $otherg
		`groupadd $otherg > /dev/null 2>&1`
		`usermod -G $otherg ${username[$j]} > /dev/null 2>&1`	
            done
            #otherg=`echo ${group[$j]} | awk -F ',' '{print $1}'
            
	fi
    done
else
    echo "File not found"
fi
