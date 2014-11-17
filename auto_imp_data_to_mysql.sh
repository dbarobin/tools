#!/bin/bash
#Author:Robin
#Date:2014-11-4 15:43:25
#Desc:Auto import cmms data to MySQL. Use this script in RHEL 6.1. If you want use this script in Debian/Ubuntu, just change the Source function library.

#变量定义  
#数据库名
SQLNAME="cmms.sql"
#脚本路径名
DIR="/root"
#MySQL主机地址
HOST="xxx.xxx.xxx.xxx"
#登录用户名
USER="cmms"
#登录密码
PASSWD="0Bna8m91Cf"
#导入数据库名
DBNAME="cmms"


# Source function library. Diff in Debian/Ubuntu.
. /etc/rc.d/init.d/functions

case $1 in
	testLogin)
		echo "Test Log in MySQL."
		#导入前可以使用此命令测试登录
		mysql -h$HOST -u$USER -p$PASSWD
		if [ $? -eq 0  ]; then
			echo "Login successful!"
		else
			echo "Login failed, please check your info."
		fi
    ;;
   	imp)
		# 导入SQL存在，则导入。不存在提示错误信息
		if [ -f $DIR/$SQLNAME ]; then
			#导入sql文件到指定数据库
			echo "Waiting for the imp daemon process import data. " \ " 
Don't stop the imp process unless it auto exit."
			mysql -h$HOST -u$USER -p$PASSWD $DBNAME < $DIR/$SQLNAME
			if [ $? -eq 0  ]; then
				echo "Import data successful!"
			else
				echo "Import failed!"
			fi
		else
			echo "$SQLNAME not found, please check $SQLNAME exists in the $DIR"
		fi
    ;;
   	*)
		echo "Usage $0  [testLogin|imp]"
    ;;
esac
