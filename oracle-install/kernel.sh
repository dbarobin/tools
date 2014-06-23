#!/bin/sh
#
#scripts by robin  2013-11-11
#
#added user to install oracle database software
#
#
ouser=`groupmems -g dba -l|awk '{print $1}'`

sed  '/kernel.sem/d' -i  /etc/sysctl.conf
sed  '/fs.file-max/d' -i  /etc/sysctl.conf
sed  '/fs.aio-max-nr/d' -i  /etc/sysctl.conf
sed  '/net.ipv4.ip_local_port_range/d' -i  /etc/sysctl.conf
sed  '/net.core.rmem_default/d' -i  /etc/sysctl.conf
sed  '/net.core.wmem_default/d' -i  /etc/sysctl.conf
sed  '/net.core.rmem_max/d' -i  /etc/sysctl.conf
sed  '/net.core.wmem_max/d' -i  /etc/sysctl.conf
sed '/net.bridge.bridge/d' -i /etc/sysctl.conf

echo "kernel.sem = 1250 640000  1250  512" >> /etc/sysctl.conf
echo "fs.file-max = 68157440"  >> /etc/sysctl.conf
echo "fs.aio-max-nr = 68157440"  >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 9000 65500" >> /etc/sysctl.conf
echo "net.core.rmem_default = 4194304"  >> /etc/sysctl.conf
echo "net.core.wmem_default = 4194304"  >> /etc/sysctl.conf
echo "net.core.rmem_max = 4194304"  >> /etc/sysctl.conf
echo "net.core.wmem_max = 4194304"  >> /etc/sysctl.conf

sysctl -p

sed "/$ouser/d"  -i /etc/security/limits.conf >/dev/null 2>&1
cat >> /etc/security/limits.conf  <<-EOF
*                 soft    nproc    2047
*                 hard    nproc   16384
*                 soft    nofile   1024
*                 hard    nofile  65536
EOF

