# Tools-By Robin Wen #

## Project Summary ##

> Tools of MySQL, Oracle and Shell. This scripts collected via work. You may get massive useful skills throgh the script.

## Version Information ##
> Majority of scripts pass-test in RHEL 6.1, part of scripts pass-test in Debian 7.6/Ubuntu 14.04. I will give clear indication of this scripts in the **Scripts and Dirs Summary**.

## Change Log ##

2014-06-11
> Documentation version is **1.0**, Documentation name is **Tools-By Robin Wen**, Comment is **All of Scripts pass-test**, By Robin。

2014-11-11
> Documentation version is **2.0**, Documentation name is **Tools-By Robin Wen**, Comment is **All of Scripts pass-test**, By Robin。

2014-11-19
> Documentation version is **2.1**, Documentation name is **Tools-By Robin Wen**, Comment is **Add the startup and shutdown scripts of nginx**, By Robin。

2014-11-20
> Documentation version is **2.2**, Documentation name is **Tools-By Robin Wen**, Comment is **Add auto install and config apt-fast script**, By Robin。

2014-12-12
> Documentation version is **2.3**, Documentation name is **Tools-By Robin Wen**, Comment is **Add monodb startup script.**, By Robin。

2015-01-13
> Documentation version is **2.3.1**, Documentation name is **Tools-By Robin Wen**, Comment is **Add shell_arguments_passing.sh.**, By Robin。

2015-01-31
> Documentation version is **2.3.2**, Documentation name is **Tools-By Robin Wen**, Comment is **Add tool of auto deploy app.**, By Robin。

2015-04-10
> Documentation version is **2.3.3**, Documentation name is **Tools-By Robin Wen**, Comment is **Add multiple tools.**, By Robin。

## Lists of File ##

* auto_backup_database.sh [shell]
* auto_backup_file.sh [shell]
* auto_create_bondnetwork.sh [shell]
* auto_get_untransferred_shop.sh [shell]
* auto_import_data.sh [shell]
* auto_install_lamp.sh [shell]
* auto_install_lnmp.sh [shell]
* auto_config_mysql.sh [shell]
* auto_install_oracle_pageup_plugin.sh [shell]
* avoid_dos.sh [shell]
* batch_add_user.sh [shell]
* init_opt_system_robinwen.sh [shell]
* oracle-install [d]
* libvirt-bootstrap-robin.sh [shell]
* auto_fix_bash_bug.sh [shell]
* auto_imp_data_to_mysql.sh [shell]
* nginx_old [shell]
* nginx [shell]
* auto_install_config_apt_fast.sh [shell]
* mongod [shell]
* mongod_debian [shell]
* shell_arguments_passing.sh [shell]
* auto_update_master.sh [shell]
* auto_deploy.sh [shell]
* mysql-master-slave-on-one-server [d]
* mysql_trigger_audit.sql [sql]
* raneto [shell]
* raneto.sh [shell]
* multiple_line_comments.sh [shell]
* multiple_mysql.sh [shell]

## Scripts and Dirs Summary ##

### auto_backup_database.sh [shell] ###
> Backup MySQL databases. Use this script in RHEL 6.1.

### auto_backup_file.sh [shell] ###
> Auto backup files to remote file server. Use this script in RHEL 6.1.

### auto_create_bondnetwork.sh [shell] ###
> Auto create bondnetwork. Use this script in RHEL 6.1.

### auto_get_untransferred_shop.sh [shell] ###
> Auto get untransfferd shop infomation. Use this script in RHEL 6.1.

### auto_import_data.sh [shell] ###
> Auto Import Data To MS SQL. Use this script in RHEL 6.1.

### auto_install_lamp.sh [shell] ###
> LAMP:Linux + Apache + MySQL + PHP
> Auto install LAMP in rhel 6.1. Use this script in RHEL 6.1. You must prepare the following packages in the opt dir: mysql-5.1.59.tar.gz, httpd-2.2.21.tar.gz, php-5.3.6.tar.bz2.

### auto_install_lnmp.sh [shell] ###
> LNMP:Linux + Nginx + MySQL + PHP
> Auto install LNMP in rhel 6.1. Use this script in RHEL 6.1. You must prepare the following packages in the opt dir: mysql-5.1.59.tar.gz, nginx-1.2.6.tar.gz, php-5.3.6.tar.bz2.

### auto_config_mysql.sh [shell] ###
> Auto config mysql after the mysql installation.

### auto_install_oracle_pageup_plugin.sh [shell] ###
> Auto Install SQL*Plus Pageup Plugin Uniread. Use this script in RHEL 6.1.

### avoid_dos.sh [shell] ###
> Analyze /var/log/httpd/access_log to avoid dos attack. Use this script in RHEL 6.1.

### batch_add_user.sh [shell] ###
> Batch add user in production env. Use this script in RHEL 6.1.

### init_opt_system_robinwen.sh [shell] ###
> Script of Initialize and Optimizie Linux System. Use this script in RHEL 6.1.

### oracle-install [d] ###
> Install database software 11g  on your system. You may to use this scripts as root. Use this script in RHEL 6.1. CD the oracle-install dir, see the readme.txt, the you got it!

### libvirt-bootstrap-robin.sh [shell] ###
> Install libvirt and KVM for webvirtmgr. See at: https://github.com/retspen/webvirtmgr

### auto_fix_bash_bug.sh [shell] ###
> Auto fix bash bug. Use this script in all of linux distribution. Bug see at: http://seclists.org/oss-sec/2014/q3/650

### auto_imp_data_to_mysql.sh [shell] ###
> Auto import cmms data to MySQL. Use this script in RHEL 6.1. If you want use this script in Debian/Ubuntu, just change the Source function library.

### nginx_old [shell] ###
> Nginx startup and shutdown script. Function of this script including start nginx, stop nginx, restart nginx and check nginx status. Use this script in RHEL 6.1. If you want use this script in Debian/Ubuntu, just change the Source function library.

### nginx [shell] ###
> This script starts and stops the nginx daemon. Function of this script including  start nginx, stop nginx, restart nginx, reload nginx, force reload nginx, test nginx configuration, and check nginx status. Use this script in RHEL 6.1. If you want use this script in Debian/Ubuntu, just change the Source function library.

### auto_install_config_apt_fast.sh [shell] ###
> Auto install and config apt-fast, use apt-fast instead apt-get. See at: http://xmodulo.com/speed-slow-apt-get-install-debian-ubuntu.html. Use this script in Debian 7.6 and run as root.

### mongod_debian [shell] ###
> Mongodb startup and shutdown script version 1.0. Use this script in Debian 7.6 and run as root.

### mongod [shell]###
>  Mongodb startup and shutdown script version 2.0. Use this script in Debian 7.6 and run as root.

### shell_arguments_passing.sh [shell]###
>  Passing arguments on shell.

### auto_update_master.sh [shell]###
>  Auto sync local repo to Github.

### auto_deploy.sh [shell] ###
>  Tool of auto deploy, see at: http://git.io/F85N

### mysql-master-slave-on-one-server [d] ###
> MySQL replication. Shutdown and startup scripts of master and slave on one server.

### mysql_trigger_audit.sql [sql] ###
> MySQL audit trigger test scripts.

### raneto [shell] ###
> Shutdown and startup srcript of raneto, which is a static markdown supported websites based on Node.js.

### raneto.sh [shell] ###
> Raneto related shutdown and startup scripts.

### multiple_line_comments.sh [shell] ###
> Mulitple line comments in the Shell scripts.

### multiple_mysql.sh [shell] ###
> Scripts of multiple MySQL instance on one server.

Enjoy!

## About Author ##

温国兵

* Robin Wen
* Gmail：blockxyz@gmail.com
* BLog：http://dbarobin.com
* GitHub：https://github.com/dbarobin

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/dbarobin/tools/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
