	.arch armv6
	.fpu vfp
	.text

@ print function is complete, no modifications needed
    .global	print
print:
    /* parameters: from in r0, to in r1 */
	stmfd	sp!, {r3, lr}
	mov	r3, r0
	mov	r2, r1
	ldr	r0, startstring
	mov	r1, r3
	bl	printf
	ldmfd	sp!, {r3, pc}

startstring:
	.word	string0

    .global	towers
towers:
   /* parameters: numDiscs in r0, start in r1, goal in r2 */
   /* callee-saved registers: steps in r4, peg in r5 */
	push	{r0-r2, r4, r5, lr}
   /* Save callee-saved registers to stack */
	str	r4, [sp, #12]
	str	r5, [sp, #16]
   /* Save a copy of all 3 incoming parameters */
	str	r0, [sp]
	str	r1, [sp, #4]
	str	r2, [sp, #8]
if:
   /* If numdiscs >= 2, branch to else */
	cmp	r0, #2
	bge	else
   /* Print the move and set return to 1 */
	mov	r0, r1
	mov	r1, r2
	bl	print
	mov	r0, #1
	b	endif
else:
   /* Calculate the intermediate peg */
	mov	r5, #6 
	sub	r5, r5, r1
	sub	r5, r5, r2
   /* towers(numdiscs-1, start, peg) */
	ldr	r0, [sp]
	sub	r0, r0, #1
	mov	r2, r5
	bl	towers
   /* Move result to callee-saved register for total steps */
	mov	r4, r0
   /* towers(1, start, goal) */
	mov	r0, #1
	ldr	r1, [sp, #4]
	ldr	r2, [sp, #8]
	bl	towers
   /* Add result to total steps so far */
	add	r4, r4, r0
   /* towers(numDiscs-1, peg, goal) */
	ldr	r0, [sp]
	sub	r0, r0, #1
	mov	r1, r5
	ldr	r2, [sp, #8]
	bl towers
   /* Add result to total steps so far and save it to return register */
	add	r0, r0, r4

endif:
   /* Restore Registers */
	add	sp, sp, #4
	pop	{r1, r2, r4, r5, pc}

@ Function main is complete, no modifications needed
    .global	main
main:
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
	ldr	r0, printdata
	bl	printf
	ldr	r0, printdata+4
	add	r1, sp, #12
	bl	scanf
	ldr	r0, [sp, #12]
	mov	r1, #1
	mov	r2, #3
	bl	towers
	str	r0, [sp]
	ldr	r0, printdata+8
	ldr	r1, [sp, #12]
	mov	r2, #1
	mov	r3, #3
	bl	printf
	mov	r0, #0
	add	sp, sp, #20
	ldr	pc, [sp], #4
end:

printdata:
	.word	string1
	.word	string2
	.word	string3

string0:
	.asciz	"Move from peg %d to peg %d\n"
string1:
	.asciz	"Enter number of discs to be moved: "
string2:
	.asciz	"%d"
	.space	1
string3:
	.ascii	"\n%d discs moved from peg %d to peg %d in %d steps."
	.ascii	"\012\000"
