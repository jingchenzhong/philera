ip link set wlan0 up
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 11 essid $(perl -e 'print "\xc3\xdb\xb9\xde"') key 's:fuckyougirl!!'
iwconfig wlan0
sleep 5
dhcpcd wlan0
