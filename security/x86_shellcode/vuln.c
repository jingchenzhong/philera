#include <string.h>
#include <stdio.h>

unsigned long sp ()
{
    __asm__ ("movl %esp, %eax");
}

int main (int argc, char *argv[])
{
    char buffer[500];
    printf ("0x%x\t0x%x\n", buffer, sp());
    strcpy (buffer, argv[1]);
    return 0;
}
