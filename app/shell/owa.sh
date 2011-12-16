#!/bin/bash

if (( $# != 2 ))
then
    echo "Usage: $0 <user> <passwd>"
    exit -1
fi

USER="$1"
PASSWD="$2"

UA="Opera/9.80 (X11; Linux i686; U; en) Presto/2.10.229 Version/11.60"

REFER="https://webmail.nokiasiemensnetworks.com/Exchweb/bin/auth/owalogon.asp?url=https://webmail.nokiasiemensnetworks.com/Exchange&reason=0"

AUTH_URL="https://webmail.nokiasiemensnetworks.com/Exchweb/bin/auth/owaauth.dll"

COOKIES="cookies.txt"


RESULT=$(curl -s -m 5 -L -A $UA -c $COOKIES -b $COOKIES -d "destination=https://webmail.nokiasiemensnetworks.com/Exchange&flags=0&trusted=4&username=$USER&password=$PASSWD" $AUTH_URL)

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "$RESULT"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

RESULT=$(curl -s -m 5 -A $UA -b $COOKIES -c COOKIES -L -e $REFER -G 'https://webmail.nokiasiemensnetworks.com/Exchange/leilei.wang/Inbox/?Cmd=contents&Page=1&View=%E9%82%AE%E4%BB%B6')

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "$RESULT"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
