#!/bin/bash

declare -i count=0
array=`cat page_1.html`
array=${array:1}
if [[ $1 != "" ]]
then
    declare -i b=21
    (( b=b*$1 ))
    array=${array:$b}
    count=$1
fi

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
    name="${3}%CB%${aa}%B9%${bb}"
    card=${card:1:18}
    tele="0379-39${dd}${cc}${dd}"
    echo "name=$name card=$card tele=$tele socks=$2"
    ./auto_sub.sh $name $card $tele "$2"
    echo ""
    echo "put proxy server ip:"
    echo ""
    (( count++ ))
    echo "===================================="
    echo "@5 i=${count} http_proxy=${http_proxy}"
    echo "===================================="
    #sleep 120
    #read proxy
    #if [[ $proxy != "" ]]
    #then
    #    export http_proxy=http://${proxy}
    #fi

done
IFS="$oldifs"


