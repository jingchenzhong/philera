#!/bin/bash

if (( $# < 1 ))
then
    echo "Usage: $0 <url from youku>"
    exit -1
fi
web_url=$1
web_url=http%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XMzE1Mjg3NjA4.html

errcode=1

# get url address
curl -s -A 'Mozilla/4.0' "http://www.flvcd.com/parse.php?kw=$web_url&flag=&format=" |  
sed -n 's/^.*\"\(http[^ ]*sid[^ ]*\)\".*$/\1/p' | tee /tmp/url.log

errcode=$?
if (( $errcode != 0 ))
then
    rm -rvf /tmp/url.log
    exit $errcode
fi

# download video from real site 
errcode=1
while (( $errcode != 0 ))
do
   aria2c -d . -c -i /tmp/url.log
   errcode=$?
done

#rm -rvf /tmp/url.log

# generate playlist
date=`date +%Y%m%d%H%M%S`
sed -n 's/^.*fileid\/\([^ ?=]*\).*$/\1.flv/p' /tmp/url.log > ./all_$date.playlist

exit 0

