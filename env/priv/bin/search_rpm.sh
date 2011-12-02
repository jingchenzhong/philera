#!/bin/bash

#PROXY="http://10.144.1.10:8080"

URI="http://rpmfind.net/linux/rpm2html/search.php?query="$1"&\
submit=Search+...&system=&arch=1"

#USER_AGENT="Opera/9.80 (X11; Linux i686; U; en) Presto/2.9.168 \
#Version/11.52"
#export http_proxy=$PROXY
curl -s $URI > /tmp/tmp.html

sed -n '37,$s/<[^<>]*>/\n/gp' /tmp/tmp.html 

#rm tmp.html


