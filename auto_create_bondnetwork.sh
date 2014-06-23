#!/bin/bash
#Author:Robin Wen
#Date:2013年8月31日8:29:22
#Desc:Auto create bondnetwork

ifconfig eth0:0 192.168.137.1 netmask 255.255.255.0
ifconfig eth0:1 192.168.138.1 netmask 255.255.255.0
ifconfig eth0:2 192.168.139.1 netmask 255.255.255.0

ifconfig | grep eth: -A1
