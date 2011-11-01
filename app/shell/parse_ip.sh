#!/bin/bash
curl -v -o proxy.html "http://www.cnproxy.com/proxy2.html"
ips=`sed -n 's/^.*<td>\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]\).*$/\1/gp' proxy.html`

for ip in $ips
do
    ping -c 1 $ip
    if (( $? != 0 ))
    then
        echo "ip is non-existed"
        continue
    fi
    echo "========>$ip"
    export http_proxy=http://$ip:80 
    rm -rvf tmp.html
    curl -v -o tmp.html "http://www.tool7001.com"
    if (( $? != 0 ))
    then
        export http_proxy=http://$ip:8080 
        rm -rvf tmp.html
        curl -v -o tmp.html "http://www.tool7001.com"
    fi
    if (( $? == 0 ))
    then
        grep -n 'is invalid' tmp.html
        if (( $? != 0 ))
        then
            echo $http_proxy >> valid_ip.txt
        else
            echo "<===================invalid====================>"
        fi
    fi
done
