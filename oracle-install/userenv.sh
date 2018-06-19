#!/bin/bash
#
#scripts by robin  2013-11-11
#
#set env to install oracle database software
#
#
ouser=`groupmems  -g dba  -l|awk '{print $1}'`

obase=$1

if [ "$obase" != "" ];then
  echo "------ set env  starting ------------------------------------------------"
  if  [ ! -d $obase ];then
    mkdir  $obase  -p >/dev/null 2>&1
    chown  $ouser:dba $obase -R >/dev/null 2>&1
  fi

  sed  '13,$d' -i /home/$ouser/.bash_profile  
  sed '/^export $PATH/'d  -i /home/$ouser/.bash_profile 
  cat >>/home/$ouser/.bash_profile <<-EOF

export ORACLE_BASE=`ls $obase -d |sed 's#/$##'`
export ORACLE_HOME=\$ORACLE_BASE/db11g
export PATH=\$ORACLE_HOME/bin:\$PATH

EOF

  sed 's#//#/#g' /home/$ouser/.bash_profile -i
  echo "dir : $obase  owner : $ouser   group : dba"
  echo "------ set env  succesefull ---------------------------------------------"
else 
  echo "Please enter ORACLE_BASE dir  to install database software !"
  echo "such as   /u01/oracle ."
fi

