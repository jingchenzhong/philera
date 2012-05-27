#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char *argv[])
{
    FILE *fd;
    
    char *userinput = malloc(20);
    char *outputfile = malloc(20);

    if (argc < 2) {
        printf ("Usage: %s <string to be written to /tmp/notes>\n", argv[0]);
        exit (-1);
    }

    strcpy (outputfile, "/tmp/notes");
    strcpy (userinput, argv[1]);


    printf ("---DEBUG---\n");
    printf ("[*] userinput @ %p: %s\n", userinput, userinput);
    printf ("[*] outputfile @ %p: %s\n", outputfile, outputfile);
    printf ("[*] distance between: %d\n", outputfile - userinput);
    printf ("-------\n\n");

    printf ("Writing to \"%s\" to the end of %s...\n", userinput, outputfile);
    fd = fopen (outputfile, "a");
    if (fd == NULL) {
        fprintf (stderr, "error opening %s\n", outputfile);
        exit (1);
    }

    fprintf (fd, "%s\n", userinput);
    fclose (fd);
    
    return 0;
}

