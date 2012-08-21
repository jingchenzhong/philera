myloader.bin: *.S
	arm-linux-gcc -g -c -DTEXT_BASE=0x33F80000 -march=armv4 \
	  -o start.o start.S
	arm-linux-ld  -g -T myloader.lds -Ttext 0x33f80000 -Bstatic \
	  start.o -o myloader
	arm-linux-objdump -d myloader > myloader.objdump
	arm-linux-objdump -dS myloader > myloader.objdumpS
	arm-linux-readelf -a myloader > myloader.readelf
	arm-linux-objcopy --gap-fill=0xff -O binary \
	  myloader myloader.bin
clean:
	rm -rvf *.o myloader.bin myloader.readelf myloader.objdump* myloader
