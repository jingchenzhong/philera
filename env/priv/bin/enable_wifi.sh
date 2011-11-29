LC_ALL="zh_CN.GB2312"
ip link set eth0 down
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
ip link set wlan0 up
iwconfig wlan0 channel 11 essid ÃÛ¹Þ key s:fuckyougirl\!\!
sleep 5
ifconfig wlan0 192.168.0.124 netmask 255.255.255.0 broadcast 192.168.0.255
iwconfig wlan0 channel 11 essid ÃÛ¹Þ key s:fuckyougirl\!\!
sleep 5
route add default gw 192.168.0.1
mv /etc/resolv.conf /etc/resolv.conf.bak_
echo "domain mshome.net" > /etc/resolv.conf
echo "nameserver 192.168.0.1" >> /etc/resolv.conf
iwconfig
ifconfig
route
cat /etc/resolv.conf
