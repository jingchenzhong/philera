#include <stdio.h>
#include <cvmx.h>
#include <cvmx-flash.h>

int main(void)
{

    cvmx_flash_initialize();
    void *flash_ptr = cvmx_flash_get_base(0);
    printf ("0x%016llx\n", (unsigned long long)flash_ptr);
    printf("\n");
    printf("Hello world!\n");

    printf("Hello example run successfully.\n");
    return 0;
}
