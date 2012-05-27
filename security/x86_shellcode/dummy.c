extern int system(const char *command);
int main (int argc, char *argv[], char *env[])
{
    char buf[10] = {0};
    printf ("argc:%p, argv:%p,env:%p\n", &argc, argv, env);

    printf ("system:%p\n", &system);
    strcpy (buf, argv[1]);
}
