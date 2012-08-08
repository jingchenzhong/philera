#include "opsdata.h"

#include <asm/ptrace.h>
#include <stdio.h>
#include <stdlib.h>


int main (int argc, char *argv[])
{
    printf ("%s %s\n", __TIME__, __DATE__);
    char data[256] = {0};
    long i = -1;
    long addr = 0x10001c10;
    struct pt_regs regs = {{0}};
    pid_t traced_process = 0;

    if(argc != 2) {
        printf("Usage: %s <pid to be traced>\n",
               argv[0], argv[1]);
        exit(1);
    }
    traced_process = atoi(argv[1]);   

    lib_init (traced_process);

    getregs(traced_process, &regs);
    long *ptr = (long *)&regs;
    for (i = 0;i < sizeof (struct pt_regs) / sizeof (long);i ++) {
        printf ("0x%08x\n", *(ptr ++));
    }
    getdata(traced_process, addr, data, 256);

    i = -1;
    while (++i < 256) {
        printf ("0x%02x\n", *(data+i));
    }

    lib_destroy (traced_process);

    return 0;
}

