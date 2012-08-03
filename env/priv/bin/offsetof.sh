#!/bin/bash


if (( $# != 1 ))
then
    echo "Usage: `basename $0` <elf with debug info>"
    echo "NOTE: export CROSS_COMPILE=powerpc-linux-gnu- for embeded system"
    exit 3
fi

dwarf_file=`basename $1`.dwarf
rm -f $dwarf_file

${CROSS_COMPILE}objdump -W $1 > $dwarf_file
if (( $? != 0 ))
then
    echo "ELF file could not be recongnized by ${CROSS_COMPILE}objdump"
    echo "NOTE: export CROSS_COMPILE=powerpc-linux-gnu- for embeded system"
    exit 4
fi


isstruct=0
ismember=0
struct_name="ANONYMOUS"
member_name="ANONYMOUS"
struct_size=0
member_offset=0


while read line_str
do
    if [[ $line_str == *"(DW_TAG_structure_type)"* ]]
    then
        isstruct=1
        continue
    fi

    if (( $isstruct ))
    then

        if [[ $line_str =~ "DW_AT_name" ]]
        then
            echo ""
            echo "/* struct ${line_str##*: }; */"
            struct_name=`tr [a-z] [A-Z] <<< "${line_str##*: }"`
            continue
        fi

        if [[ $line_str =~ "DW_AT_byte_size" ]]
        then
            struct_size=${line_str##*: }
            echo "#define T_${struct_name}_SIZE ${struct_size}"
            continue
        fi

        if [[ $line_str == *"(DW_TAG_member)"* ]]
        then
            ismember=1
            isstruct=0
            continue
        fi
    fi

    if (( $ismember ))
    then
       if [[ $line_str =~ "DW_AT_name" ]]
        then
            member_name=`tr [a-z] [A-Z] <<< "${line_str##*: }"`
            continue
        fi

        if [[ $line_str =~ "DW_OP_plus_uconst" ]]
        then
            member_offset=${line_str##*: }
            member_offset=${member_offset%)*}
            echo "#define T_${struct_name}_${member_name}_OFFSET ${member_offset}"
            continue
        fi

    fi


    if [[ $line_str =~ "^ <1>" ]]
    then
        isstruct=0
        ismember=0
        struct_name="ANONYMOUS"
        member_name="ANONYMOUS"
        struct_size=0
        member_offset=0
        continue
    fi

done < $dwarf_file

rm -f $dwarf_file
exit
