#!/bin/bash
# Author: Robin Wen
# Date: 2014-11-07 17:58:07
# Desc: Install libvirt and KVM for webvirtmgr. See at:https://github.com/retspen/webvirtmgr

# Install_redhat_post
if [ -f /etc/sysconfig/libvirtd ]; then
    sed -i 's/#LIBVIRTD_ARGS/LIBVIRTD_ARGS/g' /etc/sysconfig/libvirtd
else
    echoerror "/etc/sysconfig/libvirtd not found. Exiting..."
    exit 1
fi
if [ -f /etc/libvirt/libvirtd.conf ]; then
    sed -i 's/#listen_tls/listen_tls/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#listen_tcp/listen_tcp/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#auth_tcp/auth_tcp/g' /etc/libvirt/libvirtd.conf
else
    echoerror "/etc/libvirt/libvirtd.conf not found. Exiting..."
    exit 1
fi
if [ -f /etc/libvirt/qemu.conf ]; then
    sed -i 's/#vnc_listen/vnc_listen/g' /etc/libvirt/qemu.conf
else
    echoerror "/etc/libvirt/qemu.conf not found. Exiting..."
    exit 1
fi

# Daemons_running_redhat
if [ -f /etc/init.d/libvirtd ]; then
    service libvirtd stop > /dev/null 2>&1
    service libvirtd start
fi
if [ -f /etc/init.d/libvirt-guests ]; then
    service libvirt-guests stop > /dev/null 2>&1
    service libvirt-guests start
fi
if [ -f /usr/lib/systemd/system/libvirtd.service ]; then
    systemctl stop libvirtd.service > /dev/null 2>&1
    systemctl start libvirtd.service
fi
if [ -f /usr/lib/systemd/system/libvirt-guests.service ]; then
    systemctl stop libvirt-guests.service > /dev/null 2>&1
    systemctl start libvirt-guests.service
fi
