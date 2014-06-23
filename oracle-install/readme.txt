
install  database software  11g  on your system . you may to use this scripts.
all script execute  using  root  
step 0.   install packages .
          mounted rhel6-64bit install Media into CD/DVD driver .   
          execute script : /opt/updba/foway/oracle-install/rpm.sh   
          
step 1.   set hostname . 
          execute script : /opt/updba/foway/oracle-install/hostnameset.sh   <hostname>.  
          such as    /opt/updba/foway/oracle-install/hostnameset.sh crmdb

step 2.   added user .
          execute script :  /opt/updba/foway/oracle-install/useradd.sh  <username> .
          such as    /opt/updba/foway/oracle-install/useradd.sh  oracle

step 3.   set kernel parameter .  
          execute script :  /opt/updba/foway/oracle-install/kernel.sh 

step 4.   set env .    
          execute script :  /opt/updba/foway/oracle-install/userenv.sh   <ORACLE_BASE> .
          such as    /opt/updba/foway/oracle-install/userenv.sh  /u01/oracle

step 5.   install  database software only . 
          mounted  11.2.0.3-64bit  install media into CD/DVD driver .
	  execute script : /opt/updba/foway/oracle-install/install.sh 

step 6.   create database .  
          execute script : /opt/updba/foway/oracle-install/db.sh  <ORACLE_SID>  <ORADATA>.
          such as    /opt/updba/foway/oracle-install/db.sh  updb	 /u02/oradata
	  
