#include <stdio.h>
#include <cvmx.h>


int main(void)
{
    printf("\n");
    printf("\n");
    printf("Hello world!\n");

    simprintf("Hello again - a big number is 0x%llx\n", 0x1234567887654321ULL);

    printf("Hello example run successfully.\n");
    return 0;
}
