#!/bin/bash
#if [[ $# < 1 ]]
#then
#    echo "Usage: $0 <randCode>"
#    exit -1
#fi


url1="https://dynamic.12306.cn/otsweb/login.jsp"


ua="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"

cookie=cookie.txt
page=page.html
jpg=randcode.jpg


rm -rvf "$cookie" "$page" "$jpg"

# get the jsid from login page
curl -k -L -A"$ua" -D "$cookie" -b "$cookie" -o page.html "${url1}" 
jsid=`sed -n '/jsessionid/p' page.html | sed -n 's/^.*jsessionid=\([A-Z0-9]*[^?]*\)?.*$/\1/p'`

# get randcode picture
random=`awk 'BEGIN{srand();printf("%.17f",rand())}'`
url2="https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=lrand&${random}"
url2="https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=lrand"
curl -k -A "$ua" -D "$cookie" -b "$cookie" -o "$jpg" -e "$url1" "$url2"

feh "$jpg"&

randcode=`djpeg -greyscale -pnm "$jpg" | ocrad --charset=ascii --scale=60`

echo "randcode=${randcode}"

read -t 10 -p "Please correct rancode: " randcode1

echo ""

if [[ "$randcode1" != "" ]]
then
    randcode=$randcode1
fi

echo "randcode=${randcode}"


# generate current login url via current jsid 
url2="https://dynamic.12306.cn/otsweb/loginAction.do;jsessionid=${jsid}?method=login"

# login system
form="loginUser.user_name=nicephil@gmail.com&nameErrorFocus=&user.password=wangleihero&passwordErrorFocus=&randCode=${randcode}&randErrorFocus="

curl -v -k -L -A "$ua" -D "$cookie" -b "$cookie" -o page.html -d "${form}" -e "$url1" "${url2}"
if (( $? != 0 ))
then
    exit -1
fi

cat page.html


exit -2

#if (( $? != 0 ))
#then
#    exit -1
#fi

#grep '您今天提交过于频繁' page.html
#if (( $? == 0 ))
#then
#    echo "!!!!!!!!!!!!!!!!!!!!error so sleep 180"
#    sleep 240
#fi

