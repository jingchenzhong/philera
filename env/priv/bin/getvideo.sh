#!/bin/bash

if (( $# < 2 ))
then
    echo "Usage: $0 <url from youku> <dest path>"
    exit -1
fi
web_url=`echo $1 | sed -n 's/:/%3A/g;s/\//%2F/gp'` 

errcode=1
if [[ -d $2 ]]
then
    TPATH=$2
else
    TPATH=.
    echo 'wrong path, so use pwd'
fi


# get url address
curl -s -A 'Mozilla/4.0' "http://www.flvcd.com/parse.php?kw=$web_url&flag=&format=" | \
sed -n -e '/getFlvPath/s/^.*\(http[^ ]*\).*$/\1/p' | sed -e '/\.\.\.\./d' -e '//d' > $TPATH/url.log 


errcode=$?
if (( $errcode != 0 ))
then
    rm -rvf $TPATH/url.log
    echo "failed"
    exit $errcode
fi

# generate playlist
sed -n 's/^.*fileid\/\([^ ?=]*\).*$/\1.flv/p' $TPATH/url.log > $TPATH/all.playlist
mv $TPATH/url.log $TPATH/all_url.playlist


# download video from real site 
errcode=1
while (( $errcode != 0 ))
do
   aria2c --file-allocation=none -d $TPATH -c -i $TPATH/all_url.playlist
   #wget --user-agent="Mozilla/4.0" -P $TPATH -i $TPATH/all_url.playlist

   errcode=$?
done



exit 0

