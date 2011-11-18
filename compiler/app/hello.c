/*
 * =====================================================================================
 *
 *       Filename:  hello.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  11/16/2011 12:19:24 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */
void swap (int *a, int *b)
{
    *a ^= *b ^= *a ^= *b;
}

int main()
{
    int a = 100;
    int shared = 10;
    swap (&a, &shared);
    return 0;
}
