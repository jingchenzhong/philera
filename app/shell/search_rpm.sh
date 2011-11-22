#!/bin/bash

URI="http://rpmfind.net/linux/rpm2html/search.php?query="$1"&\
submit=Search+...&system=&arch=1"

USER_AGENT="Opera/9.80 (X11; Linux i686; U; en) Presto/2.9.168 \
Version/11.52"

curl $URI > tmp.html

elinks  tmp.html

rm tmp.html


