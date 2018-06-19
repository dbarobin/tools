#!/bin/bash
#Author:Robin Wen
#Desc:Auto Install SQL*Plus Pageup Plugin Uniread. Use this script in RHEL 6.1.

#1.Install dependency
yum install perl* -y
yum install ncurses* cyrus-imapd* "*readline*" -y

#2.Unzip install files
tar -xzvf /opt/IO-Tty-1.07.tar.gz -C /opt
tar -xzvf /optTerm-ReadLine-Gnu-1.16.tar.gz -C /opt
tar -xzvf /opt/uniread-1.01.tar.gz -C /opt

#3.Install IO-Tty
cd /opt/IO-Tty-1.07
perl Makefile.PL
make && make install

#4.Install Term readline
cd /opt/Term-ReadLine-Gnu-1.16
perl Makefile.PL
make && make install

#5.Install uniread
cd /opt/uniread-1.01
perl Makefile.PL
make && make install

#6.Test
su - oracle
db
uniread sqlplus / as sysdba
