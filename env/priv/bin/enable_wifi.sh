ping -c 1 192.168.0.1
ret=$?
while (( ret !=0 ))
do
    ip link set wlan0 down
    iwconfig wlan0 mode ad-hoc
    iwconfig wlan0 channel 11 essid $(perl -e 'print "\xc3\xdb\xb9\xde"') key 's:fuckyougirl!!'
    ip link set wlan0 up
    sleep 5
    iwconfig wlan0
    dhcpcd wlan0
    ping -c 1 192.168.0.1
    ret=$?
done
