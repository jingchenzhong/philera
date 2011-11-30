#!/bin/bash

wget -q -U Mozilla -O /tmp/output.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=$1" && mplayer -quiet /tmp/output.mp3
