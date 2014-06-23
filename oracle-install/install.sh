#!/bin/sh
#
#scripts by robin  2013-11-11
#
#silent install oracle database software
#
#

ouser=`groupmems   -g dba -l|awk '{print $1}'`

if [ ! -d /robin ];then
   mkdir /robin
fi
   
   umount /dev/cdrom  >/dev/null 2>&1
   umount /robin  >/dev/null 2>&1
   mount /dev/cdrom /robin >/dev/null 2>&1

ls /robin/p10404530_112030_Linux-x86-64_{1,2}of7.zip
if  [ $? -eq 0 ];then 
  echo  "---------------------install  11.2.0.3 starting -----------------------------"
  rm  /tmp/database  -rf  >/dev/null 2>&1
  unzip /robin/p10404530_112030_Linux-x86-64_1of7.zip -d /tmp >/dev/null 2>&1
  unzip /robin/p10404530_112030_Linux-x86-64_2of7.zip -d /tmp >/dev/null 2>&1
  source /home/$ouser/.bash_profile
  rm $ORACLE_BASE/oraInventory/logs/silentInstall*  -rf >/dev/null 2>&1
  su - $ouser  -c "/tmp/database/runInstaller  -silent  -responsefile /tmp/database/response/db_install.rsp oracle.install.option=INSTALL_DB_SWONLY  ORACLE_BASE=$ORACLE_BASE ORACLE_HOME=$ORACLE_HOME  UNIX_GROUP_NAME=oinstall INVENTORY_LOCATION=$ORACLE_BASE/oraInventory oracle.install.db.InstallEdition=EE SELECTED_LANGUAGES=en,zh_CN oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.3.0,oracle.oraolap:11.2.0.3.0,oracle.rdbms.dm:11.2.0.3.0,oracle.rdbms.dv:11.2.0.3.0,oracle.rdbms.lbac:11.2.0.3.0,oracle.rdbms.rat:11.2.0.3.0  DECLINE_SECURITY_UPDATES=true oracle.install.db.DBA_GROUP=dba oracle.install.db.OPER_GROUP=dba  ORACLE_HOME_NAME=OraDbHome11g"

ocount=1
until  [ -e $ORACLE_BASE/oraInventory/logs/silentInstall`date +%Y-%m-%d`*.log ]
do
sleep 2s
ocount=$ocount+1
done

sleep  30s

$ORACLE_BASE/oraInventory/orainstRoot.sh

echo y|$ORACLE_HOME/root.sh

sed 's/^ORACLE_HOME_LISTNER=/#ORACLE_HOME_LISTNER=/' $ORACLE_HOME/bin/dbshut -i
sed '/#ORACLE_HOME_LISTNER=/ a ORACLE_HOME_LISTNER=$ORACLE_HOME' $ORACLE_HOME/bin/dbshut -i

sed 's/^ORACLE_HOME_LISTNER=/#ORACLE_HOME_LISTNER=/' $ORACLE_HOME/bin/dbstart -i
sed '/#ORACLE_HOME_LISTNER=/ a ORACLE_HOME_LISTNER=$ORACLE_HOME' $ORACLE_HOME/bin/dbstart -i

echo  "---------------------install 11.2.0.3  successefull--------------------------"
else
echo  "please mounted database 11.2.0.3 software install CD media  to /media dir."
echo  "such command as :  mount /dev/cdrom /media " 
fi

rm  /tmp/database   -rf  > /dev/null  2>&1
ummount  /robin  > /dev/null  2>&1
rm  /robin  -rf  > /dev/null 2>&1

