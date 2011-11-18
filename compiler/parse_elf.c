//#!/usr/bin/tcc -run
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stddef.h>

#include <unistd.h>

#define DEBUG

typedef unsigned long long Elf64_Addr;
typedef unsigned short Elf64_Half;
typedef unsigned long long Elf64_Off;
typedef int Elf64_Sword;
typedef long long Elf64_Sxword;
typedef unsigned int Elf64_Word;
typedef unsigned long long Elf64_Xword;
typedef unsigned char Elf64_Byte;
typedef unsigned short Elf64_Section;

typedef struct elf64_hdr_t {
    unsigned char e_ident[16];
    Elf64_Half e_type;
    Elf64_Half e_machine;
    Elf64_Word e_version;
    Elf64_Addr e_entry;
    Elf64_Off e_phoff;
    Elf64_Off e_shoff;
    Elf64_Word e_flags;
    Elf64_Half e_ehsize;
    Elf64_Half e_phentsize;
    Elf64_Half e_phnum;
    Elf64_Half e_shentsize;
    Elf64_Half e_shnum;
    Elf64_Half e_shstrndx;
} ELF64_HDR_T;

typedef struct elf64_shr_t {
    Elf64_Word sh_name;
    Elf64_Word sh_type;
    Elf64_Xword sh_flags;
    Elf64_Addr sh_addr;
    Elf64_Off sh_offset;
    Elf64_Xword sh_size;
    Elf64_Word sh_link;
    Elf64_Word sh_info;
    Elf64_Xword sh_addralign;
    Elf64_Xword sh_entsize;
} ELF64_SHR_T;

typedef struct elf64_mips_odhr_t {
    Elf64_Byte kind;
    Elf64_Byte size;
    Elf64_Section section;
    Elf64_Word info;
    unsigned char data[0];
} ELF64_MIPS_ODHR_T;

typedef struct elf64_dyn_t {
    Elf64_Xword d_tag;
    union {
        Elf64_Xword d_val;
        Elf64_Addr d_ptr;
    } d_un;
} ELF64_DYN_T;

void getb8 (void *val, void *addr)
{
    *(unsigned char *)val = *(unsigned char *)addr;
#ifdef DEBUG
    printf ("0x%02x\n", *(Elf64_Byte*)val);
#endif
}

void putb8 (void *addr, void *val)
{
    *(unsigned char *)addr = *(unsigned char *)val;
}

void getb16 (void *val, void *addr)
{
    int i = 0;
    for (i = 0; i < 2; i ++) {
        *((unsigned char *)val+i) = *((unsigned char *)addr+1-i);
    }
#ifdef DEBUG
    printf ("0x%04x\n", *(Elf64_Half*)val);
#endif
}

void putb16 (void *addr, void *val)
{
    int i = 0;
    for (i = 0; i < 2; i ++) {
        *((unsigned char *)addr+i) = *((unsigned char *)val+1-i);
    }
}
void getb32 (void *val, void *addr)
{
    int i = 0;
    for (i = 0; i < 4; i ++) {
        *((unsigned char *)val+i) = *((unsigned char *)addr+3-i);
    }
#ifdef DEBUG
    printf ("0x%08x\n", *(Elf64_Word*)val);
#endif
}

void putb32 (void *addr, void *val)
{
    int i = 0;
    for (i = 0; i < 4; i ++) {
        *((unsigned char *)addr+i) = *((unsigned char *)val+3-i);
    }
}
void getb64 (void *val, void *addr)
{
    int i = 0;
    for (i = 0; i < 8; i ++) {
        *((unsigned char *)val+i) = *((unsigned char *)addr+7-i);
    }
#ifdef DEBUG
    printf ("0x%016llx\n", *(Elf64_Xword*)val);
#endif
}

void putb64 (void *addr, void *val)
{
    int i = 0;
    for (i = 0; i < 8; i ++) {
        *((unsigned char *)addr+i) = *((unsigned char *)val+7-i);
    }
}

void getoneodhr (ELF64_MIPS_ODHR_T *mem, unsigned char *file_op_ptr)
{
    getb8(&(mem->kind), file_op_ptr+
            offsetof(ELF64_MIPS_ODHR_T, kind));
    getb8(&(mem->size), file_op_ptr+
            offsetof(ELF64_MIPS_ODHR_T, size));
    getb16(&(mem->section), file_op_ptr+
            offsetof(ELF64_MIPS_ODHR_T, section));
    getb32(&(mem->info), file_op_ptr+
            offsetof(ELF64_MIPS_ODHR_T, info));
}

void getoneshdr (ELF64_SHR_T *mem, unsigned char *file_shr_ptr)
{
    getb32(&(mem->sh_name), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_name));
    getb32(&(mem->sh_type), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_type));
    getb64(&(mem->sh_flags), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_flags));
    getb64(&(mem->sh_addr), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_addr));
    getb64(&(mem->sh_offset), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_offset));
    getb64(&(mem->sh_size), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_size));
    getb32(&(mem->sh_link), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_link));
    getb32(&(mem->sh_info), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_info));
    getb64(&(mem->sh_addralign), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_addralign));
    getb64(&(mem->sh_entsize), file_shr_ptr+
            offsetof(ELF64_SHR_T, sh_entsize));
}

int main(int argc, char **argv)
{
    int fd = -1;
    int size = 0;
    unsigned char *file_ptr = NULL;
    int ret = 0;
    int i = 0;
    Elf64_Word word = 0;
    Elf64_Xword xword = 0;
    Elf64_Half half = 0;
    ELF64_HDR_T *elf64_hdr_ptr = NULL;
    ELF64_SHR_T *elf64_shr_ptr = NULL;
    ELF64_SHR_T *elf64_shr_str_ptr = NULL;

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

    file_ptr = (unsigned char *)mmap (NULL, size, PROT_WRITE|PROT_READ, MAP_PRIVATE, fd, 0);
    if ( MAP_FAILED == file_ptr) {
        perror ("mmap");
        fprintf (stderr, "line_%d:mmap failed\n", __LINE__);
        ret = -3;
        goto __cleanup;
    }
    printf ("file_ptr:0x%08x\n", file_ptr);

    /* elf64_hdr */
    elf64_hdr_ptr = (ELF64_HDR_T *)calloc (1, sizeof (ELF64_HDR_T));

    /* e_ident[16] */
    memcpy (elf64_hdr_ptr->e_ident, file_ptr, 16);
#ifdef DEBUG
    printf ("ELF HEADER:\n");
    for (i = 0; i < 16; i ++) {
        printf ("0x%02x\n", *((elf64_hdr_ptr->e_ident)+i));
    }
#endif
    /* e_type */
    getb16(&(elf64_hdr_ptr->e_type), file_ptr+offsetof(ELF64_HDR_T, e_type));

    /* e_machine */
    getb16(&(elf64_hdr_ptr->e_machine), file_ptr+
            offsetof(ELF64_HDR_T, e_machine));
    /* e_version */
    getb32(&(elf64_hdr_ptr->e_version), file_ptr+
            offsetof(ELF64_HDR_T, e_version));
    /* e_entry */
    getb64(&(elf64_hdr_ptr->e_entry), file_ptr+
            offsetof(ELF64_HDR_T, e_entry));
    /* e_phoff */
    getb64(&(elf64_hdr_ptr->e_phoff), file_ptr+
            offsetof(ELF64_HDR_T, e_phoff));
    /* e_shoff */
    getb64(&(elf64_hdr_ptr->e_shoff), file_ptr+
            offsetof(ELF64_HDR_T, e_shoff));
    /* e_flags */
    getb32(&(elf64_hdr_ptr->e_flags), file_ptr+
            offsetof(ELF64_HDR_T, e_flags));
    /* e_ehsize */
    getb16(&(elf64_hdr_ptr->e_ehsize), file_ptr+
            offsetof(ELF64_HDR_T, e_ehsize));
    /* e_phentsize */
    getb16(&(elf64_hdr_ptr->e_phentsize), file_ptr+
            offsetof(ELF64_HDR_T, e_phentsize));
    /* e_phnum */
    getb16(&(elf64_hdr_ptr->e_phnum), file_ptr+
            offsetof(ELF64_HDR_T, e_phnum));
    /* e_shentsize */
    getb16(&(elf64_hdr_ptr->e_shentsize), file_ptr+
            offsetof(ELF64_HDR_T, e_shentsize));
    /* e_shnum */
    getb16(&(elf64_hdr_ptr->e_shnum), file_ptr+
            offsetof(ELF64_HDR_T, e_shnum));
    /* e_shstrndx */
    getb16(&(elf64_hdr_ptr->e_shstrndx), file_ptr+
            offsetof(ELF64_HDR_T, e_shstrndx));

    /* e_ident[16] */
    if (memcmp (elf64_hdr_ptr->e_ident, "\x7f""ELF\x2\x2\x1\x0\x0\x0\x0\x0\x0\x0\x0\x0", 16)) {
        fprintf (stderr, "it's not a MIPS64 ELF\n");
    }

    /* section headers */
    elf64_shr_ptr = (ELF64_SHR_T *)calloc(elf64_hdr_ptr->e_shnum, sizeof (ELF64_SHR_T));
    unsigned char *file_shr_ptr = (unsigned char *)(file_ptr+
           elf64_hdr_ptr->e_shoff);

    /* .shstrtab */
    elf64_shr_str_ptr = elf64_shr_ptr+elf64_hdr_ptr->e_shstrndx;
    unsigned char *file_shr_str_ptr = file_shr_ptr+(elf64_hdr_ptr->e_shstrndx * sizeof (ELF64_SHR_T));
    
#ifdef DEBUG
    printf (".shstrtab:\n");
#endif
    getoneshdr (elf64_shr_str_ptr, file_shr_str_ptr);

    unsigned char *file_str_tab_ptr = file_ptr + elf64_shr_str_ptr->sh_offset; 

    /* .mips.options */
    ELF64_SHR_T *elf64_shr_op_ptr = elf64_shr_ptr+1;
    unsigned char *file_shr_op_ptr = file_shr_ptr+1*sizeof(ELF64_SHR_T);
    getb32(&word, file_shr_op_ptr+
            offsetof(ELF64_SHR_T, sh_name));
    printf ("%s: \n", file_str_tab_ptr+word);
    getoneshdr(elf64_shr_op_ptr, file_shr_op_ptr);
    printf (".mips.optins:sh_size:0x%016llx\n", elf64_shr_op_ptr->sh_size);

    unsigned char *file_option_tab_ptr = file_ptr + elf64_shr_op_ptr->sh_offset;
    ELF64_MIPS_ODHR_T *elf64_mips_odhr_ptr = (ELF64_MIPS_ODHR_T *)malloc (sizeof (ELF64_MIPS_ODHR_T));
    printf ("odhr-reginfo: \n");
    getoneodhr(elf64_mips_odhr_ptr, file_option_tab_ptr);
    elf64_mips_odhr_ptr = (ELF64_MIPS_ODHR_T *) realloc(elf64_mips_odhr_ptr, elf64_mips_odhr_ptr->size);
    /* ri_gprmask */
    getb32(&(elf64_mips_odhr_ptr->data[0]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data));
    /* ri_pad */
    getb32(&(elf64_mips_odhr_ptr->data[4]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+4);
    /* ri_cprmask[0] */
    getb32(&(elf64_mips_odhr_ptr->data[8]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+8);
    /* ri_cprmask[1] */
    getb32(&(elf64_mips_odhr_ptr->data[12]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+12);
    /* ri_cprmask[2] */
    getb32(&(elf64_mips_odhr_ptr->data[16]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+16);
    /* ri_cprmask[3] */
    getb32(&(elf64_mips_odhr_ptr->data[20]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+20);
    /* ri_gp_value */
    getb64(&(elf64_mips_odhr_ptr->data[24]), file_option_tab_ptr +
            offsetof(ELF64_MIPS_ODHR_T, data)+24);

    /* .dymanic */
    ELF64_SHR_T *elf64_shr_dym_ptr = elf64_shr_ptr+2;
    unsigned char *file_shr_dym_ptr = file_shr_ptr+2*sizeof(ELF64_SHR_T);
    getb32(&word, file_shr_dym_ptr+
            offsetof(ELF64_SHR_T, sh_name));
    printf ("%s: \n", file_str_tab_ptr+word);
    getoneshdr(elf64_shr_dym_ptr, file_shr_dym_ptr);


__cleanup:
    if (-1 != fd) {
        close (fd);
    }

    if (MAP_FAILED != file_ptr) {
        munmap (file_ptr, size);
    }

    if (NULL != elf64_hdr_ptr) {
        free (elf64_hdr_ptr);
    }

    if (NULL != elf64_shr_ptr) {
        free (elf64_shr_ptr);
    }

    if (NULL != elf64_mips_odhr_ptr) {
        free (elf64_mips_odhr_ptr);
    }

    return ret;
    
}

