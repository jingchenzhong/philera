#!/bin/bash
ln -s myloader.bin u-boot.bin
cmd="qemu-system-arm -s -S\
    -kernel $base/uImage
	-M mini2440 $* \
	-serial stdio \
    -mtdblock nand128.bin \
	-show-cursor \
	-usb -usbdevice keyboard -usbdevice mouse \
    -net nic,vlan=0 -net tap,vlan=0,ifname=tap0,script=./qemu-ifup,downscript=./qemu-ifdown \
	-monitor telnet::5555,server,nowait"


echo $cmd
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sudo $cmd
unlink u-boot.bin
