#ifndef __OPS_DATA_H
#define __OPS_DATA_H
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/user.h>
void lib_init (pid_t child);
void getdata(pid_t child, long addr, char *str, int len);
void putdata(pid_t child, long addr, char *str, int len);
void getregs (pid_t child, struct pt_regs *regs);
void setregs (pid_t child, struct pt_regs *regs);
void lib_destroy (pid_t child);
#endif
