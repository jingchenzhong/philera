LNX=/home/phil/repos/aeros/kernel/linux-2.6.32

rm -rvf files.list

#notes change line number
for DIR in `tail -n +41 $0`
do
    echo "===>$LNX/$DIR"
    find $LNX/$DIR -name "*.[chxsSCHiI]" -print >> files.list
done

cscope -bqkU -i files.list
ctags -L files.list

exit

Documentation
block
fs
init
mm
scripts
CVS
samples
virt
sound
kernel
crypto
include
drivers
firmware
tools
net
ipc
usr
arch
security
lib
~~~~~~~~~~~~~~~~~~~~~~~~~~

include
arch/powerpc
arch/mips
arch/arm
kernel
net
ipc
lib
init
mm

