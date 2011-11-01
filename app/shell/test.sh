#!/bin/bash

array=`cat page_1.html`

oldifs="$IFS"
IFS=","
name="%D3%DA%CA%BE%B7%B6"
tele="0379-65689466"


for card in ${array}
do
    aa=`printf "%02x" $(( ${RANDOM}%256|160 ))`
    bb=`printf "%02x" $(( ${RANDOM}%256|160 ))`
    cc=`printf "%02d" $(( ${RANDOM}%100 ))`
    dd=`printf "%02d" $(( ${RANDOM}%100 ))`
    name="%D3%DA%CA%${aa}%B7%${bb}"
    card=${card:1:18}
    tele="0379-68${dd}${cc}${dd}"
    #echo $name $card $tele
    ./auto_sub.sh $name $card $tele
    echo ""
    echo "put proxy server ip:"
    echo ""
    read proxy
    if [[ $proxy != "" ]]
    then
        export http_proxy=http://${proxy}:8080
    fi
    echo $http_proxy

done
IFS="$oldifs"


