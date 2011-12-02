#!/bin/bash

if (( $# < 1 ))
then
    echo "Usage: $0 <url from youku>"
    exit -1
fi
web_url=`echo $1 | sed -n 's/:/%3A/g;s/\//%2F/gp'` 

errcode=1

# get url address
curl -s -A 'Mozilla/4.0' "http://www.flvcd.com/parse.php?kw=$web_url&flag=&format=" |\
    sed -n '/getFlvPath/s/^.*\(http[^ ]*\).*$/\1/p' > url.log 


errcode=$?
if (( $errcode != 0 ))
then
    rm -rvf url.log
    echo "failed"
    exit $errcode
fi

# download video from real site 
errcode=1
while (( $errcode != 0 ))
do
   aria2c -d . -c -i url.log
   errcode=$?
done


# generate playlist
date=`date +%Y%m%d%H%M%S`
sed -n 's/^.*fileid\/\([^ ?=]*\).*$/\1.flv/p' url.log > all_$date.playlist

mv url.log all_url_$date.playlist

exit 0

