#!/bin/bash
if [[ $# < 2 ]]
then
    echo "Usage: $0 <name> <card> <tele>"
    exit -1
fi

form="act=i&kind=yanshi&jianyi1=&jianyi2=&jianyi3=&jianyi4=&xinyongshe5=0&\
jianyi5=%3Cp%3E%B0%EC%C0%ED%D2%B5%CE%F1%B2%BB%B4%ED%A3%AC%B5%D8%C3%E6%D5%FB\
%BD%E0%3C%2Fp%3E%3Cp%3E%B0%EC%C0%ED%D2%B5%CEa%F1%B2%BB%B4%ED%A3%AC%B5%D8%C3%E6\
%D5%FB%BD%E0%3C%2Fp%3E%3Cp%3E%B0%EC%C0%ED%D2%B5%CE%F1%B2%BB%B4%ED%A3%AC%B5%D8\
%%C3%E6%D5%FB%BD%E0%B0%EC%C0%ED%D2%B5%CE%F1%B2%BB%B4%ED%A3%AC%B5%D8%C3%E6%D5\
%FB%BD%E0%3C%2Fp%3E%3Cp%3E%3CBr+%2F%3E%B0%EC%C0%ED%D2%B5%CE%F1%B2%BB%B4%ED%A3\
%AC%B5%D8%C3%E6%D5%FB%BD%E0%3C%2Fp%3E%3Cp%3E%B0%EC%C0%ED%D2%B5%CE%F1%B2%BB%B4\
%ED%A3%AC%B5%D8%C3%E6%D5%FB%BD%E0%3C%2Fp%3E%3Cp%3E%B0%EC%C0%ED%D2%B5%CE%F1%B2\
%%BB%B4%ED%A3%AC%B5%D8%C3%E6%D5%FB%BD%E0%3C%2Fp%3E\
&xinyongshe6=2&jianyi6=%3Cp%3E%CC%AB%C2%FD%A3%AC%CC%AC%B6%C8%B2%BB%BA\
%C3%3C%2Fp%3E%3Cp%3E%CC%AB%C2%FD%A3%AC%CC%AC%B6%C8%B2%BB%BA%C3%3C%2Fp%3E%3Cp%3E\
%CC%AB%C2%FD%A3%AC%CC%AC%B6%C8%B2%BB%BA%C3%3C%2Fp%3E%3Cp%3E%3Cbr+%2F%3E%3C%2Fp\
%3E%3Cp%3E%CC%AB%C2%FD%A3%AC%CC%AC%B6%C8%B2%BB%BA%C3%3C%2Fp%3E%3Cp%3E%CC%AB%C2\
%FD%A3%AC%CC%AC%B6%C8%B2%BB%BA%C3%3C%2Fp%3E%3Cp%3E%CC%AB%C2%FD%A3%AC%CC%AC%B6\
%%C8%B2%BB%BA%C3%3C%2Fp%3E\
&jianyi7=&jianyi8=&jianyi9=&jianyi10=&jianyi11=&\
jianyi12=&jianyi13=&jianyi14=&jianyi15=&jianyi16=&\
jianyi17=&jianyi18=&jianyi19=&jianyi20=&jianyi21=&jianyi22=&jianyi23=&\
jianyi24=&jianyi25=&jianyi26=&jianyi27=&jianyi28=&jianyi29=&jianyi30=&\
jianyi31=&jianyi32=&jianyi33=&jianyi34=&jianyi35=&jianyi36=&jianyi37=&\
jianyi38=&jianyi39=&jianyi40=&jianyi41=&jianyi42=&jianyi43=&jianyi44=&\
jianyi45=&jianyi46=&jianyi47=&jianyi48=&jianyi49=&jianyi50=&jianyi51=&\
jianyi52=&jianyi53=&jianyi54=&jianyi55=&jianyi56=&jianyi57=&jianyi58=&\
jianyi59=&jianyi60=&jianyi61=&jianyi62=&jianyi63=&jianyi64=&jianyi65=&\
jianyi66=&jianyi67=&jianyi68=&jianyi69=&jianyi70=&jianyi71=&jianyi72=&\
jianyi73=&jianyi74=&name=$1&card=$2&\
tele=$3&btn_submit2=%CC%EE%BA%C3%C1%CB%A3%AC%CC%E1%BD%BB"

url1="http://www2.lyd.com.cn/20110419pingxuan/20111025_xinyongshe_IBSL.asp"

url="http://www2.lyd.com.cn/20110419pingxuan/20111025_xinyongshe_IBSL_sub.asp"

ua="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"

cookie=cookie0001.txt
page=page.html







rm -rvf "$cookie" "$page"



curl $4 -A "$ua" -o page.html -D "$cookie"  "$url1"
if (( $? != 0 ))
then
    exit -1
fi
sleep 3
curl $4 -A "$ua" -b "$cookie" -o page.html -d "$form" -e "$url1" "$url"
if (( $? != 0 ))
then
    exit -1
fi

cat page.html
if (( $? != 0 ))
then
    exit -1
fi

sleep 1

grep '您今天提交过于频繁' page.html
if (( $? == 0 ))
then
    echo "!!!!!!!!!!!!!!!!!!!!error so sleep 180"
    sleep 180
fi

