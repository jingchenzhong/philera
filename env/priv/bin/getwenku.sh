#!/bin/bash
#http://wenku.baidu.com/view/2183fa87e53a580216fcfea0.html?l=3.2.2
#baseurl='http://wenku.baidu.com/view/d96cbffbf705cc17552709c4.html?l=2.1.2'

function usage ()
{
    echo "Usage: $1 <wenkuurl> [outputfilename]"
    echo 'Example:./getwenku.sh http://wenku.baidu.com/view/b3391cc32cc58bd63186bd53.html?l=2.1.2'
    exit $2
}

function main ()
{
    local fileid="$1"
    local totalpage="1"
    local frompage="1"
    local filebaseurl="http://ai.wenku.baidu.com/play"
    local filename=""
    local finalname="$2"
    local progname=$0
    local errno=-1
    progname=${progname##*/}

    #extract fileid from wenku url
    fileid=${fileid##*/}
    fileid=${fileid%%.*}
    echo "fileid: ${fileid}"
    if [[ "$fileid" == "" ]]
    then
        errno=1
        usage $progname $errno
    fi

    #final name
    if [[ "$finalname" == "" ]]
    then
        finalname="$fileid"
    fi

    if [[ -x "${finalname}.pdf" ]]
    then
        errno=3
        echo "${finalname}.pdf is existed"
        exit errno
    fi

    #parse how many pages in this file
    totalpage=$(wget -c -q -O - "${filebaseurl}/${fileid}?pn=1&rn=1" | \
        head -n1 | \
        awk -F'"' '{print $4,$8,$12}')
    totalpage=${totalpage%% *}
    echo "totalpage: ${totalpage}"
    if [[ $totalpage == "" ]]
    then
        errno=2
        usage $progname $errno
    fi

    #fetch each page from wenku
    while (( $frompage <= $totalpage ))
    do
        (\
        filename=${fileid}_${frompage};\
        wget -c -q -O ${filename} "${filebaseurl}/${fileid}?pn=${frompage}&rn=1";\
        echo "page ${frompage} downloaded";\
        dd bs=106 skip=1 if=${filename} of=${filename}.swf &>/dev/null;\
        swfrender -o $filename.png ${filename}.swf;\
        rm ${filename};\
        echo "page ${frompage} converted to PNG";\
        )&
        echo "page ${frompage} ...."
        let frompage+=1
    done 

    #wait for all PNGs done
    wait

    #generate proper PDF
    convert ${fileid}*.png -compress zip -colors 256 -colorspace GRAY \
            -resize 1020x1320 -density 120x120 -units PixelsPerInch ${finalname}.pdf

    rm ${fileid}*.png ${fileid}*.swf
    echo "${finalname}.pdf generated"
}

main $*
