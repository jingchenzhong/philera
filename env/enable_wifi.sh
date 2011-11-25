#!/bin/bash

LC_ALL="zh_CN.GB2312"

mv /etc/resolv.conf /etc/resolv.conf.bak_
echo "domain mshome.net" >> /etc/resolv.conf
echo "nameserver 192.168.0.1" >> /etc/resolv.conf
ifconfig eth0 down
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
ip link set wlan0 up
iwlist wlan0 scan
iwconfig wlan0 essid √€πﬁ key s:fuckyougril\!\!
iwconfig wlan0
route add default gw 192.168.0.1
ifconfig wlan0
route
cat /etc/resolv.conf
