#!/bin/bash

mplayer -really-quiet "http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=$1" &> /dev/null
