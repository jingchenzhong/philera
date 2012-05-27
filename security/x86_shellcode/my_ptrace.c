#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>

int main (int argc, char *argv[])
{
    int pid = 0;
    int wait_val = 0;
    long long counter = 1;

    switch (pid = fork()) {
        case 0:
            ptrace (PTRACE_TRACEME, 0, 0, 0);

            execl ("/bin/ls", "ls", 0);
            break;
        default:
            wait (&wait_val);

            while (WIFSTOPPED(wait_val)) {
                if (ptrace (PTRACE_SINGLESTEP, pid, (caddr_t)1, 0)) break;

                wait (&wait_val);

                counter ++;
            }
    }
    printf ("==%lld\n", counter);
}
