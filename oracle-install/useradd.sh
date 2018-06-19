#!/bin/sh
#
#scripts by robin  2013-11-11
#
#added user to install oracle database software
#
#

ouser=$1
if [ "$ouser" != "" ];then
 echo "------ added user  $ouser  starting ------------------------------------------------"
 
 groups  oinstall >/dev/null  2>&1
 if [ $? -eq 1 ];then
    groupadd  -g  110  oinstall  >/dev/null 2>&1
 fi

 groups  dba >/dev/null 2>&1
 if [ $? -eq 1 ];then
    groupadd  -g  111  dba  >/dev/null 2>&1
 fi

 id $ouser >/dev/null 2>&1

 if [ $? -eq 1 ];then
   useradd  $ouser -u 110  -g oinstall  -G dba >/dev/null 2>&1
   echo oracle|password  $ouser --stdin >/dev/null 2>&1
 else 
   echo oracle|password  $ouser --stdin >/dev/null 2>&1
 fi

  echo "user $ouser info : " `id $ouser`
  echo "------ added user  $ouser  succesefull ---------------------------------------------"

else 
  echo "Please user name to install database software !"
fi
