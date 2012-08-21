.globl _start
_start:	b       start_code
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq

_undefined_instruction:	.word undefined_instruction
_software_interrupt:	.word software_interrupt
_prefetch_abort:	.word prefetch_abort
_data_abort:		.word data_abort
_not_used:		.word not_used
_irq:			.word irq
_fiq:			.word fiq

	.balignl 16,0xdeadbeef


/*
 *************************************************************************
 *
 * Startup Code (called from the ARM reset exception vector)
 *
 * do important init only if we don't start from memory!
 * relocate armboot to ram
 * setup stack
 * jump to second stage
 *
 *************************************************************************
 */


_TEXT_BASE:
	.word	TEXT_BASE

.globl _armboot_start
_armboot_start:
	.word _start

/*
 * These are defined in the board-specific linker script.
 */
.globl _bss_start
_bss_start:
	.word __bss_start

.globl _bss_end
_bss_end:
	.word _end

/* IRQ stack memory (calculated at run-time) */
.globl IRQ_STACK_START
IRQ_STACK_START:
	.word	0x0badc0de

/* IRQ stack memory (calculated at run-time) */
.globl FIQ_STACK_START
FIQ_STACK_START:
	.word 0x0badc0de


/*
 * the actual start code
 */

start_code:
	/*
	 * set the cpu to SVC32 mode
	 */
	mrs	r0,cpsr
	bic	r0,r0,#0x1f
	orr	r0,r0,#0xd3
	msr	cpsr,r0

#define pWTCON		0x53000000
#define INTMSK		0x4A000008	/* Interupt-Controller base addresses */
#define INTSUBMSK	0x4A00001C
#define CLKDIVN	0x4C000014	/* clock divisor register */

#define INTSUBMSK_val	0xffff
#define MPLLCON_val	((0x61 << 12) + (0x1 << 4) + 0x2)	/* 296.35 MHz */
#define UPLLCON_val	((0x3c << 12) + (0x4 << 4) + 0x2)	/*  47.98 MHz */
#define CLKDIVN_val	7 /* FCLK:HCLK:PCLK = 1:3:6 */
#define CAMDIVN	0x4C000018

	ldr     r0, =pWTCON
	mov     r1, #0x0
	str     r1, [r0]

	/*
	 * mask all IRQs by setting all bits in the INTMR - default
	 */
	mov	r1, #0xffffffff
	ldr	r0, =INTMSK
	str	r1, [r0]

	ldr	r1, =INTSUBMSK_val
	ldr	r0, =INTSUBMSK
	str	r1, [r0]

	/* Make sure we get FCLK:HCLK:PCLK */
	ldr	r0, =CAMDIVN
	mov	r1, #0
	str	r1, [r0]

	/* Clock asynchronous mode */
	mrc	p15, 0, r1, c1, c0, 0
	orr	r1, r1, #0xc0000000
	mcr	p15, 0, r1, c1, c0, 0


	/* enable uart */
	ldr	r0, =0x4c00000c		/* clkcon */
	ldr	r1, =0x7fff0		/* all clocks on */
	str	r1, [r0]

	/* gpio UART0 init */
	ldr	r0, =0x56000070
	mov	r1, #0xaa
	str	r1, [r0]

	/* init uart */
	ldr	r0, =0x50000000
	mov	r1, #0x03
	str	r1, [r0]
	ldr	r1, =0x245
	str	r1, [r0, #0x04]
	mov	r1, #0x01
	str	r1, [r0, #0x08]
	mov	r1, #0x00
	str	r1, [r0, #0x0c]
	mov	r1, #0x1a
	str	r1, [r0, #0x28]

    bl _fuckstart



/*
 * exception handlers
 */
	.align  5
undefined_instruction:
    bl _fuckstart

	.align	5
software_interrupt:
    bl _fuckstart

	.align	5
prefetch_abort:
    bl _fuckstart

	.align	5
data_abort:
    bl _fuckstart

	.align	5
not_used:
    bl _fuckstart

	.align	5
irq:
    bl _fuckstart

	.align	5
fiq:
    bl _fuckstart

_fuckstart:
    bl _start
