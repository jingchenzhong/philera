#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main (int argc, char *argv[])
{
    char text[1024];
    static int test_val = -72;

    if (argc < 2) {
        printf ("Usage: %s <text to print>\n", argv[0]);
        exit (-1);
    }
    strcpy (text, argv[1]);

    printf ("The right way:\n");
    printf ("%s", text);

    printf ("\nThe Wrong way:\n");
    printf (text);
    printf ("\n");

    printf("[*] test_val @ 0x%08x = %d 0x%08x\n", &test_val, test_val, test_val);

    exit (0);
}
