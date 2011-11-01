#!/bin/bash
if [[ $# < 3 ]]
then
    echo "Usage: $0 <year> <month> <day>"
    exit -1
fi

form_1="cmd=gen&p=%E6%B2%B3%E5%8D%97%E7%9C%81&c=%E6%B4%9B%E9%98%B3%E5%B8%82&\
r=%E5%B8%82%E8%BE%96%E5%8C%BA&y=${1}&m=${2}&d=${3}&g=1&n=100"
url_1="www.tool7001.com/action.php"

ua="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"

cookie=cookie0001.txt
page_1=page_1.html

rm -rvf "$cookie" "$page_1"



curl -A "$ua" -D "$cookie" -b "$cookie" -o "$page_1" -d "$form_1" -e "$url_1" "$url_1"
if (( $? != 0 ))
then
    exit -1
fi


echo "=========>errcode:$? $http_proxy"

    
