#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Desc:Auto install LNMP in rhel 6.1. Use this script in RHEL 6.1. You must prepare the following packages in the opt dir: mysql-5.1.59.tar.gz, nginx-1.2.6.tar.gz, php-5.3.6.tar.bz2.
#LNMP:Linux + Nginx + MySQL + PHP 

yum groupinstall "Development tools" -y 
###########install mysql##################
if [ -f "/opt/mysql-5.1.59.tar.gz" ]
then 
    tar -xvf /opt/mysql-5.1.59.tar.gz -C /usr/src/
    cd /usr/src/mysql-5.1.59/
    yum install ncurses-devel -y
    ./configure --prefix=/usr/local/mysql --with-extra-charsets=gbk,gb2312   --with-plugins=partition,innobase,innodb_plugin,myisam
    make && make install
    if [ $? -eq 0 ]
    then
        \cp /usr/src/mysql-5.1.59/support-files/my-medium.cnf /etc/my.cnf
         cp /usr/src/mysql-5.1.59/support-files/mysql.server /etc/init.d/mysqld
 	 chmod a+x /etc/init.d/mysqld
         mkdir /usr/local/mysql/data
         sed "/myisam_sort_buffer_size/a\datadir=/usr/local/mysql/data" /etc/my.cnf -i
	 useradd -r -M mysql -s /sbin/nologin
         chown mysql.mysql /usr/local/mysql/ -R
 	 /usr/src/mysql-5.1.59/scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/data/
	 /etc/init.d/mysqld start
	 chkconfig mysqld on
    else
        echo "mysql is not install successful" 
        exit 1
    fi
else
    echo "do not found mysql tar package"
    exit 1
fi
#########install php######################
if [ -f "/opt/php-5.3.6.tar.bz2" ]
then
    tar -xf /opt/php-5.3.6.tar.bz2 -C /usr/src/ 
    cd /usr/src/php-5.3.6/
    ./configure --prefix=/usr/local/php5 --with-mysql=/usr/local/mysql/ --with-mysql-sock=/tmp/mysql.sock
    make && make install
    cp /usr/src/php-5.3.6/php.ini-production /usr/local/php5/lib/php.ini  
    /usr/local/php5/bin/php-cgi -b 9000 &
else
    echo "do not found php tar package"
    exit 1
fi

##########install nginx###################
if [ -f "/opt/nginx-1.2.6.tar.gz" ]
then
    tar -xf /opt/nginx-1.2.6.tar.gz -C /usr/src/
    cd /usr/src/nginx-1.2.6/
    useradd -r -M  nginx
    yum install pcre-devel openssl-devel libxml2-devel -y
    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --sbin-path=/usr/sbin/
    make && make install
    if [ $? -eq 0 ]
    then
       if [ -f "/opt/nginx.conf" ]
       then
          \cp /opt/nginx.conf /usr/local/nginx/conf/
          nginx
       else
          echo "nginx.conf is not found,please sure" 
          exit 1
       fi
    else
       echo "nginx is not install successful..." 
       exit 1
    fi
else
    echo "do not found nginx tar package"
    exit 1
fi
