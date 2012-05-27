#include <stdlib.h>
#include <stdio.h>

static void cleanup (void) __attribute__ ((destructor));

int main (int argc, char *argv[])
{
    printf ("Some actions happen in the main() function..\n");
    printf ("and then when main() exits, the destructor is called..\n");

    exit (0);
}

void cleanup (void)
{
    printf ("In the cleanup function now..\n");
}
