#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>

#include "opsdata.h"

const int long_size = sizeof(long);

void lib_init (pid_t child)
{
    ptrace(PTRACE_ATTACH, child,
           NULL, NULL);
    wait(NULL);
}

void getdata(pid_t child, long addr,
             char *str, int len)
{   char *laddr;
    int i, j;
    union u {
            long val;
            char chars[long_size];
    }data;

    i = 0;
    j = len / long_size;
    laddr = str;

    while(i < j) {
        data.val = ptrace(PTRACE_PEEKDATA, child,
                          addr + i * 4, NULL);
        memcpy(laddr, data.chars, long_size);
        ++i;
        laddr += long_size;
    }
    j = len % long_size;
    if(j != 0) {
        data.val = ptrace(PTRACE_PEEKDATA, child,
                          addr + i * 4, NULL);
        memcpy(laddr, data.chars, j);
    }
    str[len] = '\0';
}

void putdata(pid_t child, long addr,
             char *str, int len)
{   char *laddr;
    int i, j;
    union u {
            long val;
            char chars[long_size];
    }data;

    i = 0;
    j = len / long_size;
    laddr = str;

    while(i < j) {
        memcpy(data.chars, laddr, long_size);
        ptrace(PTRACE_POKEDATA, child,
               addr + i * 4, data.val);
        ++i;
        laddr += long_size;
    }

    j = len % long_size;
    if(j != 0) {
        memcpy(data.chars, laddr, j);
        ptrace(PTRACE_POKEDATA, child,
               addr + i * 4, data.val);
    }
}

void getregs (pid_t child, struct pt_regs *regs)
{
    ptrace(PTRACE_GETREGS, child,
           NULL, &regs);
}

void setregs (pid_t child, struct pt_regs *regs)
{
    ptrace(PTRACE_SETREGS, child,
           NULL, &regs);
}

void lib_destroy (pid_t child)
{
    ptrace (PTRACE_DETACH, child, NULL, NULL);
}

