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

# download video from 
errcode=1
while (( $errcode != 0 ))
do
   aria2c -d /tmp -c -i /tmp/url.log
   errcode=$?
done

#rm -rvf /tmp/url.log

# merge video
date=`date +%Y%m%d%H%M%S`
rm -rvf all_$date.flv
files=`sed -n 's/^.*fileid\/\([^ ?=]*\).*$/\1.flv/p' /tmp/url.log`
for f in $files
do
    f=/tmp/$f
    size=`du -sb $f | sed -n '$s/^\([0-9^ ]*\).*$/\1/p'`
    cat $f | pv -pa -s $size >> all_$date.flv 
    if (( $? != 0 ))
    then
        exit -2
    fi
done

exit 0

