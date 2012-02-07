#!/bin/bash

Width=44
Height=18
Score=0
Level=1
WinFlag=0
SleepTime=500000
Normal="\033[0m"
Green="\033[1;37;42m"
Red="\033[1;37;41m"
Brown="\033[1;37;43m"
Blue="\033[1;35m"
Ching="\033[1;34m"
HumanLen=8
((HumanXPos=Width/2))
((HumanYPos=Height+1))
CompXPos=10
CompYPos=2
((BallXPos=RANDOM%(Width-2)))
((BallYPos=RANDOM%10))
[[ BallXPos -lt 7 ]] && ((BallXPos=7))
[[ BallYPos -lt 3 ]] && ((BallYPos=3))
BallXSpeed=1
BallYSpeed=1
BorderLeft=7
((BorderRight=Width-1))
((InfoX=BorderRight+6))
((BorderTop=CompYPos+2))
((AlertY=Height/2))
((AlertX=Width/2-3))
DrawSquare()
{
  local PaddingLen i
  Item="$Normal    $Green[]$Normal"
  ((PaddingLen=Width-4))

  Padding=""
  for((i=1;i<=PaddingLen;i+=2))
  do
    Padding=$Padding"  "
  done
  Item=$Item$Padding"$Green[]$Normal"

  tput cup 2 4
  echo -e "$Green[][][][][][][][][][][][][][][][][][][][][][]$Normal"
  for((i=1;i<Height;i++))
  do
    echo -e "$Item"
  done

  tput cup 3 $InfoX
  echo -e "$Blue Score  $Normal"
  tput cup 4 $InfoX
  echo -e "$Ching $Score  $Normal"
  tput cup 5 $InfoX
  echo -e "$Blue Level  $Normal"
  tput cup 6 $InfoX
  echo -e "$Ching $Level  $Normal"
  tput cup 8 $InfoX
  echo -e "$Blue LEFT $Normal"
  tput cup 9 $InfoX
  echo -e "$Ching J $Normal"
  tput cup 10 $InfoX
  echo -e "$Blue RIGHT $Normal"
  tput cup 11 $InfoX
  echo -e "$Ching K $Normal"
  tput cup 12 $InfoX
  echo -e "$Blue EXIT $Normal"
  tput cup 13 $InfoX
  echo -e "$Ching Q $Normal"
}

DrawBall()
{
  local OldX OldY
  OldX=$BallXPos
  OldY=$BallYPos

  ((BallXPos=BallXPos+BallXSpeed))
  ((BallYPos=BallYPos+BallYSpeed))

  if [ $BallYPos -eq $((HumanYPos-1)) -a $BallXPos -gt $((HumanXPos-2)) -a $BallXPos -lt $((HumanXPos+HumanLen)) ]
  then
    ((BallYSpeed=-1))
    ((Score=Score+1))
    ((BallXPos=BallXPos+BallXSpeed))
  fi

  if [ $SleepTime -eq 0 ]
  then
    tput cup 12 $((Width/2-10))
    echo -e "$Red\033[37m      Congratulations!      $Normal"
    tput cup 13 $((Width/2-10))
    echo -e "$Red\033[37m You are the king of games! $Normal"
    exit 0
  fi

  if [ $Score -ne 0 -a $((Score%10)) -eq 0 ]
  then
    ((Level=Level+1))
    ((Score=Score+1))
        ((SleepTime=SleepTime-5000))
  fi

  if [ $BallYPos -lt $BorderTop ]
  then
    ((BallYSpeed=1))
  fi

  if [ $BallXPos -lt $BorderLeft ]
  then
    ((BallXSpeed=1))
  fi

  if [ $BallXPos -gt $BorderRight ]
  then
        ((BallXSpeed=-1))
  fi

  if [ $BallYPos -gt $HumanYPos ]
  then
    tput cup $AlertY $AlertX
    echo -e "$Red\033[37m   GAME OVER   $Normal"
    tput cup $((AlertY+1)) $AlertX
    echo -e "$Red\033[37m               $Normal"
    tput cup $((AlertY+2)) $AlertX
    echo -e "$Red\033[37m Exit(q)       $Normal"
    tput cup $((AlertY+3)) $AlertX
    echo -e "$Red\033[37m Continue(c)   $Normal"
    exit 0
  fi

  tput cup 4 $InfoX
  echo -e "$Ching $Score  $Normal"
  tput cup 6 $InfoX
  echo -e "$Ching $Level  $Normal"

  tput cup $OldY 0
  echo -e "$Item"
  tput cup $BallYPos $BallXPos
  echo -e "$Normal$Red[]$Normal"
}

DrawHuman()
{
  tput cup $HumanYPos 6
  echo "$Padding"
  tput cup $HumanYPos $1
  echo -e "$Normal$Brown[][][][]$Normal"
}

MoveHuman()
{
  local sig Xmax
  ((Xmax=BorderRight-(HumanLen-2)))
  trap "sig=26" 26
  trap "sig=27" 27
  trap "sig=28" 28

  while :
  do
    DrawBall
    case $sig in
    26)
      [[ HumanXPos -gt BorderLeft ]] && ((HumanXPos=HumanXPos-2)) && DrawHuman $HumanXPos
    ;;
    27)
      [[ HumanXPos -lt Xmax ]] && ((HumanXPos=HumanXPos+2)) && DrawHuman $HumanXPos
    ;;
    28)
          clear
      exit 0
    ;;
    esac
    #sig=0
    usleep $SleepTime
  done
}

Restart()
{
  tput cup $AlertY 6
  echo "$Padding"
  tput cup $((AlertY+1)) 6
  echo "$Padding"
  tput cup $((AlertY+2)) 6
  echo "$Padding"
  tput cup $((AlertY+3)) 6
  echo "$Padding"
  ((BallXPos=RANDOM%(Width-2)))
  ((BallYPos=RANDOM%10))
  [[ BallXPos -lt 7 ]] && ((BallXPos=7))
  [[ BallYPos -lt 3 ]] && ((BallYPos=3))
  SleepTime=500000
  DrawHuman $HumanXPos
}

clear
Stty=`stty -g`
echo -ne "\033[?25l"
stty -echo
DrawSquare
DrawHuman $HumanXPos
{
  MoveHuman
} &

while read -s -n 1 Key
do
  case $Key in
  [jJ]) 
  kill -26 $! > /dev/null 2>&1
  ;;
  [kK]) 
  kill -27 $! > /dev/null 2>&1
  ;;
  [cC])
  if [ -z "`ps x | grep $! | grep -v "grep $!" | awk '{print $1}'`" ]
  then
  Restart
  {
        MoveHuman
  } &
  fi
  ;;

  [qQ])
  kill -28 $! > /dev/null 2>&1
  sleep 0.5
  echo -e "\033[?25h\033[${y};0H"
  stty $Stty
  clear
  exit 0
  ;;
  *)
  ;;
  esac
done
