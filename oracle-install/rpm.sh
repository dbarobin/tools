#!/bin/sh
#
#scripts by robin  2013-11-11
#
#install rpm  packages to install oracle database software
#
#
if [ ! -d /robin ];then
   mkdir  /robin
fi 

  umount /dev/cdrom  >/dev/null 2>&1
  umount /robin  >/dev/null 2>&1
  mount /dev/cdrom /robin >/dev/null 2>&1


cat >/etc/yum.repos.d/el6.repo <<-EOF
[rhel6]
name = rhel6
baseurl = file:///robin
enabled = 1
gpgcheck = 1
EOF

rpm  --import /robin/RPM-GPG-KEY* >/dev/null  2>&1

cat >/tmp/rpm.txt <<-EOF
ksh
libXtst-devel.x86_64
libXtst-devel.i686
libstdc++-devel.i686
kernel-headers
glibc-devel.i686
glibc-devel.x86_64
gnome-icon-theme
dmz-cursor-themes
sgml-common
libaio.i686
libaio.x86_64
libaio-devel.x86_64
libaio-devel.i686
ncurses-devel.x86_64
ncurses-devel.i686
elfutils-libelf-devel.x86_64
elfutils-libelf-devel.i686
compat-gcc-34
compat-gcc-34-c++
libXxf86misc.i686
libXxf86vm.i686
libXt.i686
libXt.x86_64
libXmu.x86_64
libXmu.i686
mpfr
cpp
xorg-x11-xauth
compat-gcc-34-c++
libdaemon
avahi
avahi-glib
shared-mime-info
libIDL-devel.i686
libIDL-devel.x86_64
ORBit2-devel.i686
ORBit2-devel.x86_64
GConf2-devel.i686
GConf2-devel.x86_64
gnome-vfs2-devel.i686
gnome-vfs2-devel.x86_64
libbonobo-devel.i686
libbonobo-devel.x86_64
libtool-ltdl.i686
libtool-ltdl.x86_64
unixODBC-devel.i686
unixODBC-devel.x86_64
gtk2-engines.i686
gtk2-engines.x86_64
libmcpp
mcpp
xorg-x11-server-utils
libXv-devel.i686
libXv-devel.x86_64
ConsoleKit-x11
xorg-x11-xinit
libXp-devel.i686
libXp-devel.x86_64
libXxf86dga
libdmx
xorg-x11-utils
compat-db43.i686
compat-db43.x86_64
ppl.i686
ppl.x86_64
cloog-ppl.i686
cloog-ppl.x86_64
gcc
gcc-c++
compat-libstdc++-33.i686
compat-libstdc++-33.x86_64
compat-db.i686
compat-db.x86_64
gnome-themes
system-icon-theme
system-gnome-theme
readline-devel.i686
readline-devel.x86_64
libgnome-devel.i686
libgnome-devel.x86_64
binutils-devel.i686
binutils-devel.x86_64
elfutils-devel.i686
elfutils-devel.x86_64
numactl-devel.i686
numactl-devel.x86_64
elfutils.i686
elfutils.x86_64
sysstat
make
zip
imake
unzip
EOF

yum  install -y  `cat /tmp/rpm.txt`  

yum  groupinstall  "Additional Development" "Development tools" -y

yum remove  *java*  -y  >/dev/null 2>&1

umount  /robin  >/dev/null 2>&1
rm /robin -rf >/dev/null  2>&1
