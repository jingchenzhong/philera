#!/bin/bash

if (( $# < 3 ))
then
    echo "Usage: $0 <phrase> <source-lang> <output-lang>"
    exit -1
fi

translate(){ wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'; }

translate $*
