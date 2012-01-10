#!/bin/bash
#依赖于feh看图用，curl模拟表单提交，elinks查看网页,ocrad光学字符识别验证码
#需要使用Opera的Dragonfly分析HTTP的最终提交表单


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
#random=`awk 'BEGIN{srand();printf("%.17f",rand())}'`
#url2="https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=lrand&${random}"
url2="https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=lrand"
curl -k -A "$ua" -b "$cookie" -o "$jpg" -e "$url1" "$url2"

feh "$jpg"&

randcode=`djpeg -greyscale -pnm "$jpg" | ocrad --charset=ascii --scale=60`
#export TESSDATA_PREFIX=/home/phil/priv/
#randcode=`tesseract "$jpg" rand -l eng -psm 7 && cat rand.txt`

echo "randcode=${randcode}"

read -t 50 -p "Please correct rancode: " randcode1

echo ""

if [[ "$randcode1" != "" ]]
then
    randcode=$randcode1
fi

echo "randcode=${randcode}"

jsessionid=${jsid}


# generate current login url via current jsid 
url2="https://dynamic.12306.cn/otsweb/loginAction.do?method=login"

# login system
form="loginUser.user_name=${user_name}&nameErrorFocus=&user.password=${password}&passwordErrorFocus=&randCode=${randcode}&randErrorFocus="
curl -k -L -A "$ua"  -b "$cookie" -o page.html -d "${form}" -e "$url1" "${url2}"
if (( $? != 0 ))
then
    exit -1
fi

grep "2012" page.html
errcode=$?


if (( $errcode != 0 ))
then
    echo "=======>LOGIN FAILED"
    exit -2
else
    echo "=======>LOGIN OK!"
fi

# get randcode picture
url2="https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=randp"
curl -k -A "$ua" -b "$cookie" -o "$jpg" -e "$url1" "$url2"

feh "$jpg"&

randcode=`djpeg -greyscale -pnm "$jpg" | ocrad --charset=ascii --scale=60`
#export TESSDATA_PREFIX=/home/phil/priv/
#randcode=`tesseract "$jpg" rand -l eng -psm 7 && cat rand.txt`

echo "randcode=${randcode}"

read -t 50 -p "Please correct rancode: " randcode1

echo ""

if [[ "$randcode1" != "" ]]
then
    randcode=$randcode1
fi

echo "randcode=${randcode}"


# confirmPassengerAction
url3="https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"
url4="https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=confirmPassengerInfoSingle"
url1="https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"


form="org.apache.struts.taglib.html.TOKEN=c321c016b58691a6c59a793d96243b08&\
textfield=中文或拼音首字母&\
checkbox0=0&\
orderRequest.train_date=2012-01-14&\
orderRequest.train_no=560000219200&\
orderRequest.station_train_code=2192&\
orderRequest.from_station_telecode=HZH&\
orderRequest.to_station_telecode=ZZF&\
orderRequest.seat_type_code=&\
orderRequest.ticket_type_order_num=&\
orderRequest.bed_level_order_num=000000000000000000000000000000&\
orderRequest.start_time=14:35&\
orderRequest.end_time=07:56&\
orderRequest.from_station_name=杭州&\
orderRequest.to_station_name=郑州&\
orderRequest.cancel_flag=1&\
orderRequest.id_mode=Y&\
passengerTickets=1,1,娄XX,1,4XXXXXXXXX1125147,1895XXXXXXX53,Y&\
oldPassengers=娄XX,1,41072XXXXXXXXXXX125147&\
passenger_1_seat=1&\
passenger_1_ticket=1&\
passenger_1_name=娄XX&\
passenger_1_cardtype=1&\
passenger_1_cardno=4107XXXX5147&\
passenger_1_mobileno=189XXXXX153&\
checkbox9=Y&\
passengerTickets=1,1,王XX, 1,41XXXXXX3051012,139XXXX772,Y&\
oldPassengers=王XX,1,411281XXXXXXX51012&\
passenger_2_seat=1&\
passenger_2_ticket=1&\
passenger_2_name=王XX&\
passenger_2_cardtype=1&\
passenger_2_cardno=41XXXXXXX3051012&\
passenger_2_mobileno=139XXXXXXXXXX52&\
checkbox9=Y&\
randCode=&\
orderRequest.reserve_flag=A"


curl -k -L -A "$ua" -b "$cookie" -o page1.html -d "${form}" -e "${url3}" "${url4}"

cat page1.html

exit -3


