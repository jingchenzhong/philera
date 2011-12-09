#include <stdio.h>
#include <cvmx.h>
#include <cvmx-flash.h>
#include <cvmx-sysinfo.h>

int main(void)
{

    cvmx_flash_initialize();
    void *flash_ptr = cvmx_flash_get_base(0);
    printf("\n");
    printf("Hello world! - %s\n", __TIME__);

    printf("Hello example run successfully.\n");
    return 0;
}
