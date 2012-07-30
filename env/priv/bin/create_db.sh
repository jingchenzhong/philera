LNX=/home/phil/repos/linux-2.6.32.9

if [[ -d $1 ]]
then
    LNX=$1
else
    echo "Usage: $0 <kernel dir>"
    exit -1
fi

echo "SELECTED KERNEL FILES: $LNX"

find  $LNX -maxdepth 5 \
    -path "$LNX/arch/*" ! -path "$LNX/arch/powerpc*" \
        ! -path "$LNX/arch/arm*" ! -path "$LNX/arch/mips*" -prune -o \
    -path "$LNX/include/asm-*" ! -path "$LNX/include/asm-powerpc*" \
        ! -path "$LNX/inclue /asm-arm*" ! -path "$LNX/include/asm-mips*" -prune -o \
	-path "$LNX/fs/*/*" ! -path "$LNX/fs/squashfs*" -prune -o \
	-path "$LNX/tmp*" -prune -o \
	-path "$LNX/Documentation*" -prune -o \
	-path "$LNX/scripts*" -prune -o \
    -path "$LNX/drivers*" -prune -o \
	-path "$LNX/sound*" -prune -o \
	-path "$LNX/usr*" -prune -o \
	-path "$LNX/crypto*" -prune -o \
	-path "$LNX/firmware*" -prune -o \
	-path "$LNX/block*" -prune -o \
	-path "$LNX/security*" -prune -o \
	-path "$LNX/.*" -prune -o \
    -path "$LNX/.*" -prune -o \
    -path "$LNX/patches*" -prune -o \
	-path "$LNX/net*" -prune -o \
	-path "$LNX/sample*" -prune -o \
	-path "$LNX/tools*" -prune -o \
	-path "$LNX/virt*" -prune -o \
    -name "*.[chxXsSCHiI]" -print | tee files.list
echo "CSCOPE DB Generating..."
cscope -bqkU -i files.list
echo "CTAGS DB Generating..."
ctags -L files.list
echo "DB FILES:"
echo "`ls -l files.list cscope.* tags`"
echo "DB DONE"
exit 0
