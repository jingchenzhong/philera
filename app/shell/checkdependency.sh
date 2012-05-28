#!/bin/bash


# arg0 - $obj
# arg1 - $lib
function checkdependency ()
{
    local obj=$1
    local lib=$2
    undefs=`${CROSS_COMIPLE}readelf -s $obj | awk '$5 ~ /GLOBAL/{ if ($7 == "UND") print $8;}'`
    defs=`${CROSS_COMPILE}readelf -s $lib | awk '$5 ~ /GLOBAL/{if ($7 != "UND") print $8;}'`

    for undef in $undefs
    do
        for def in $defs
        do
            if [[ $undef == $def ]]
            then
                echo "$obj needs $lib"
                return 0
            fi
        done
    done
 
    echo "$obj doesn't need $lib"
    return 1
}

# main entry
# no argument
function main ()
{
    libs=`find . -name *.a`
    objs=`find . -name *.o`

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
