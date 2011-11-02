#!/bin/bash

array=`cat page_1.html`

oldifs="$IFS"
IFS=","
name="%D3%DA%CA%BE%B7%B6"
tele="0379-65689466"

declare -i count=0

for card in ${array}
do
    aa=`printf "%02x" $(( ${RANDOM}%256|160 ))`
    bb=`printf "%02x" $(( ${RANDOM}%256|160 ))`
    cc=`printf "%02d" $(( ${RANDOM}%100 ))`
    dd=`printf "%02d" $(( ${RANDOM}%100 ))`
    name="%B5%A4%CB%${aa}%B9%${bb}"
    card=${card:1:18}
    tele="0379-93${dd}${cc}${dd}"
    #echo $name $card $tele
    ./auto_sub.sh $name $card $tele
    cat "page.html"
    echo ""
    echo "put proxy server ip:"
    echo ""
    (( i++ ))
    echo "===================================="
    echo "i=${i} http_proxy=${http_proxy}"
    echo "===================================="
    sleep 120
    #read proxy
    #if [[ $proxy != "" ]]
    #then
    #    export http_proxy=http://${proxy}
    #fi

done
IFS="$oldifs"


