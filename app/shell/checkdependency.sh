#!/bin/bash


# arg0 - $obj
# arg1 - $lib
function checkdependency ()
{
    local obj=$1
    local lib=$2
    undefs=`${CROSS_COMPILE}readelf -s $obj | awk '$5 ~ /GLOBAL/{ if ($7 == "UND") print $8;}'`
    defs=`${CROSS_COMPILE}readelf -s $lib | awk '$5 ~ /GLOBAL/{if ($7 != "UND") print $8;}'`

    for undef in $undefs
    do
        for def in $defs
        do
            if [[ $undef == $def ]]
            then
                echo "[*] $lib is needed by $obj at least"
                return 0
            fi
        done
    done
 
    echo "[*] $lib is not used yet"
    return 1
}

# main entry
# arg0 - type [static, dynamic]
# arg1 - [static - code path, dynamic - elf]
function main ()
{
    if [[ $# != 2 ]]
    then
        echo "Usage: $0 [static, dynamic] [path , file]"
        exit 1
    fi

    if [[ ! -x $2 ]]
    then
        echo "path/file is invalide"
        exit 2
    fi

    if [[ $1 == "dynamic" ]]
    then
        echo "[*] the needed dynamic libs:"
        ${CROSS_COMPILE}readelf -d $2 | awk '$2 ~/NEEDED/{ if ($3 == "Shared") print $5;}'
        exit 0
    fi

    libs=`find  -name *.a`
    objs=`find . -name *.o`

    echo "[*] libs:"
    echo "$libs"
    echo "[*] objs:"
    echo "$objs"

    for lib in $libs
    do
        for obj in $objs
        do
            checkdependency $obj $lib
            if (( $? == 0 ))
            then
                break
            fi
        done
    done
}


main $*
