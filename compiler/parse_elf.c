/*
 * =====================================================================================
 *
 *       Filename:  parse_elf.c
 *
 *    Description:  parse mips64 elf running on i386
 *
 *        Version:  1.0
 *        Created:  11/11/2011 03:13:56 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <stdio.h>

#include <unistd.h>

int main(int argc, char **argv)
{
    int fd = -1;
    int size = 0;
    unsigned char *ptr = NULL;
    int ret = 0;

    if (argc != 2) {
        fprintf (stderr, "Usage: %s <elf file>\n", argv[0]);
        exit (-1);
    }

    fd = open (argv[1], O_CREAT|O_RDWR);
    if (-1 == fd) {
        perror("open");
        fprintf (stderr, "line_%d:open failed\n", __LINE__);
        ret = -1;
        goto __cleanup;
    }
    printf ("fd:%d\n", fd);

    size = lseek (fd, 0, SEEK_END);
    if ( -1 == size) {
        perror("lseek");
        fprintf (stderr, "line_%d:seek failed\n", __LINE__);
        ret = -2;
        goto __cleanup;
    }
    printf ("size:%d\n", size);

    ptr = (unsigned char *)mmap (NULL, size, PROT_WRITE|PROT_READ, MAP_PRIVATE, fd, 0);
    if ( MAP_FAILED == ptr) {
        perror ("mmap");
        fprintf (stderr, "line_%d:mmap failed\n", __LINE__);
        ret = -3;
        goto __cleanup;
    }
    printf ("ptr:0x%08x\n", ptr);

    /* e_ident[16] */
    if (memcmp (ptr, "\x7f""ELF\x2\x2\x1\x0\x0\x0\x0\x0\x0\x0\x0\x0", 16)) {
        fprintf (stderr, "it's not a MIPS64 ELF\n");
    }


__cleanup:
    if (-1 != fd) {
        close (fd);
    }

    if (MAP_FAILED != ptr) {
        munmap (ptr, size);
    }

    return ret;
    
}

