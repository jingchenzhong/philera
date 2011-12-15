#!/bin/bash

sciezka=~/scripts

kod=Hangzhou

plik=~/weather
# sprawdzenie czy serwer jest dost?pny
#if [ `ping -c1 216.109.126.70 | grep from | wc -l` -eq 0 ]
 # then
	#echo "Serwis niedost?pny"
  #else
	# pobieranie informacji
 	w3m -dump http://weather.yahoo.com/china/zhejiang/hangzhou-2132574/ | grep -A21 "Current" | sed 's/DEG/?/g' > $plik

	# ustalenie warto?ci zmiennych
	stan=`head -n3 $plik | tail -n1`
	temp=`tail -n1 $plik | awk '{print $1}'`
	tempo=`head -n6 $plik | tail -n1`
	cisn=`head -n8 $plik | tail -n1`
	wiatr=`head -n16 $plik | tail -n1`
	wilg=`head -n10 $plik | tail -n1`
	wsch=`head -n18 $plik | tail -n1`
	zach=`head -n20 $plik | tail -n1`
	if [ `cat "$sciezka"/pogodynka.sh | grep -x "# $stan" | wc -l` -eq 0 ]
	  then
		stanpl=$stan
	  else
		stanpl=`cat "$sciezka"/pogodynka.sh | grep -xA1 "# $stan" | tail -n1 | awk '{print $2,$3,$4,$5,$6,$7}'`
	fi
	
	# formatowanie informacji wyj?ciowej
	# dost?pne zmienne:
	# $stan		opis stanu po angielsku
	# $stanpl	opis stanu po polsku
	# $temp		temperatura powietrza
	# $tempo	temperatura odczuwalna
	# $cisn		ci?nienie atmosferyczne
	# $wiatr	kierunek, si?a wiatru
	# $wilg		wilgotno?? powietrza
	# $wsch		godzina wschodu s?o?ca
	# $zach		godzina zachodu s?o?ca
	
	#echo $stan
	#echo $stanpl
	echo $temp F  /  $tempo F
	#echo Cisnienie $cisn hPa
	#echo $wiatr
	#echo Wilgotno??: $wilg
	#echo Wsch?d S?o?ca: $wsch
	#echo Zach?d S?o?ca: $zach
	#echo $stanpl, $temp C

#fi


