        .nolist

#include "regdef_k64.h"
#include "kernel_k64.h"


	.text
        .set noreorder

        .list

	.org 0		/* RESET */

/* cp0 registers modification */

	mfc0	t0,C0_SR
	li	t2,0x00400004	# mask for bit(s) to be cleared: ERL->0
	li	t1,0x04000080   # mask for bit(s) to be set: FR=1, KX=1
	nor	t2,r0,t2
	and	t0,t0,t2
	or	t0,t0,t1
	mtc0	t0,C0_SR

	mfc0	t0,C0_CONFIG0
	li	t2,0x00200007	# mask for bit(s) to be cleared: L2->On, C
	li	t1,0x00000003	# mask for bit(s) to be set:	 C = 3
	nor	t2,r0,t2
	and	t0,t0,t2
	or	t0,t0,t1
	mtc0	t0,C0_CONFIG0
	mtc0	zero,C0_COMPARE

/* copy exception jumpers in ram */
	li	t0,0xbfc00000
	li	t1,0xa0000000
	ld	t2,0x200(t0)
	sd	t2,0x000(t1)
	sd	t2,0x080(t1)
	sd	t2,0x180(t1)
	ld	t2,0x208(t0)
	sd	t2,0x008(t1)
	sd	t2,0x088(t1)
	sd	t2,0x188(t1)
	ld	t2,0x210(t0)
	sd	t2,0x010(t1)
	sd	t2,0x090(t1)
	sd	t2,0x190(t1)
	ld	t2,0x218(t0)
	sd	t2,0x018(t1)
	sd	t2,0x098(t1)
	sd	t2,0x198(t1)

/* Init program stack */

	li	sp,PROGRAMM_STACK

/* Jump to test program */

	li	r2,0x80002000	# START ADDRESS = 0x FFFF FFFF 8000 2000
	jr	r2
	nop

/* Next parts of the code will be copied to a0000000, a0000080, a0000180 */

/* WARNING! ALL HANDLERS MUST BE JUST THE SAME (AS ONE)! */

	.org 0x200 	/* TLB Refill */
	mthi	t0
	dmfc0	t0,C0_EPC
	daddiu	t0,t0,4
	dmtc0	t0,C0_EPC
	mfhi	t0
	ssnop
	ssnop
	eret


	.org 0x280 	/* XTLB Refill */
	mthi	t0
	dmfc0	t0,C0_EPC
	daddiu	t0,t0,4
	dmtc0	t0,C0_EPC
	mfhi	t0
	ssnop
	ssnop
	eret

	.org 0x380 	/* Others */
	mthi	t0
	dmfc0	t0,C0_EPC
	daddiu	t0,t0,4
	dmtc0	t0,C0_EPC
	mfhi	t0
	ssnop
	ssnop
	eret


	nop
	nop
	nop
	nop
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
	.dword	0x0000000000000000
