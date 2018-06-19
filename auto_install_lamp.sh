#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Desc:Auto install LAMP in rhel 6.1. Use this script in RHEL 6.1. You must prepare the following packages in the opt dir: mysql-5.1.59.tar.gz, httpd-2.2.21.tar.gz, php-5.3.6.tar.bz2.
#LAMP:Linux + Apache + MySQL + PHP

logdir=/var/log/lamp-log
mkdir $logdir
yum groupinstall "Development tools" -y
#################Install mysql#################
if [ -f "/opt/mysql-5.1.59.tar.gz" ]
then
    tar -xvf /opt/mysql-5.1.59.tar.gz -C /usr/src > $logdir/mysql_tar.log
    cd /usr/src/mysql-5.1.59/
    yum install ncurses-devel -y > $logdir/mysql_ncurses-devel.log
    ./configure --prefix=/usr/local/mysql --with-extra-charsets=gbk,gb2312 --with-plugins=partition,innobase,innodb_plugin,myisam
    make i&& make install
    if [ $? -eq 0 ]
    then
	\cp /usr/src/mysql-5.1.59/support-files/my-medium.cnf /etc/my.cnf
	\cp /usr/src/mysql-5.1.59/support-files/mysql.server /etc/init.d/mysqld
 	chmod a+x /etc/init.d/mysqld
	sed "/myisam_sort_buffer_size/a\datadir=/usr/local/mysql/data" /etc/my.cnf -i
	groupadd mysql
	useradd -g mysql -r -M mysql -s /sbin/nologin 
	mkdir /usr/local/mysql/data
	/usr/src/mysql-5.1.59/scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/data > $logdir/mysql_init.log
	chown mysql.mysql /usr/local/mysql
	/etc/init.d/mysqld start > $logdir/mysql_start.log
	chkconfig mysqld on
    else
	echo "Install mysql is not successful!!!"
	exit 1
    fi
else
    echo "Do not found mysql tar package!!!"
    exit 1
fi


#################Install apache#################
if [ -f "/opt/httpd-2.2.21.tar.gz" ]
then
    tar -xvf httpd-2.2.21.tar.gz -C /usr/src > $logdir/httpd_tar.log
    cd /usr/src/httpd-2.2.21
    yum install zlib-devel -y > $logdir/httpd_zlib-devel.log
    ./configure --prefix=/usr/local/apache --enable-modules=all --enable-mods-shared=all --enable-so --with-mpm=worker > $logdir/httpd_configure.log
    make && make install
    if [ $? -eq 0 ]
    then
	/usr/local/apache/bin/apachectl -k start > $logdir/httpd_start.log
	hostname=`hostname`
	echo "ServerName=$hostname" >> /usr/local/apache/conf/httpd.conf
    else
	echo "Apache is not install successful..."
	exit 1
    fi
else	
    echo "Do not found apache tar package"
    exit 1
fi


#################Install php#################
if [ -f "/opt/php-5.3.6.tar.bz2" ]
then
    tar -xvf php-5.3.6.tar.bz2 -C /usr/src
    cd /usr/src/php-5.3.6/
    yum install libxml2* -y > $logdir/php_libxml2.log
    ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache/bin/apxs --with-mysql-sock=/tmp/mysql.sock --with-mysql=/usr/local/mysql/
    make && make install
    cp /usr/src/php-5.3.6/php.ini-production /usr/local/php/lib/php.ini
    if [ $? -eq 0 ]
    then
	/usr/local/php/bin/php-cgi -b 9000 &
    else
	echo "Php is not install successful..."
	exit 1
    fi
else	
    echo "Do not found php tar package"
    exit 1
fi


#################Test#################
cd /usr/local/apache/htdocs/
ip=`grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-eth0 | awk -F"=" '{print $2}'`
echo "Open browser,and input http://$ip/index.php"
echo "<?php" >> index.php
echo "	phpinfo();" >> index.php
echo "?>" >> index.php

netstat -langput | grep mysql
netstat -langput | grep 9000
netstat -langput | grep httpd

