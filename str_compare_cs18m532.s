/**********************************************************************************
* file: str_compare_cs18m532.s                                                         *
* Assembly code to Compare two strings of ASCII characters to see which is larger  *
***********************************************************************************/

@ bss section
.bss


@ data section
.data
str_len:		.word 3
str_src:		.ascii "CAT"
str_tstA:		.ascii "BAT"
str_tstB:		.ascii "CAT"
str_tstC:		.ascii "CUT"

tst_greater:	.word 0	@ Test A Greater result
				.word 0 @ Test B Greater result
				.word 0 @ Test C Greater result

@ text section
.text

.global _strCompare			@ Function which compares the given strings and returns the result

@ members on function usage

arg1		.req r0 		@ argument1 for string 1
arg2 		.req r1			@ argument2 for string 2
arg3		.req r3			@ argument3 for common length of both strings
ret			.req r4			@ return value of the function holding the result
tmp1		.req r5			@ temp member for processing
tmp2 		.req r6			@ temp member for processing
tmp3		.req r7			@ temp member for processing
result_idx	.req r8			@ argument for test result index
.global _main

_main:
	ldr   tmp1, =str_len		@ get the address of the str_len on tmp1(r5)
	ldr	  arg3, [tmp1]			@ load the length on arg3[r3]

	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstA		@ get the address of str_tstA on arg2(r1)
	bl    _strCompare			@ call to Function to compare with link
	mov   result_idx, #0		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	
	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstB		@ get the address of str_tstB on arg2(r1)
	bl    _strCompare			@ call to Function to compare with link
	mov   result_idx, #4		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	
	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstC		@ get the address of str_tstC on arg2(r1)
	bl    _strCompare			@ call to Function to compare with link
	mov   result_idx, #8		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	b 	  exit

_strCompare:
   push   {lr}					@ push the return address to stack
   mov    tmp3, arg3			@ Get the len on the tmp variable
   mov 	  ret, #0				@ init ret with 0
loop:
   ldrb   tmp1, [arg1], #1		@ load a char from arg1 
   ldrb   tmp2, [arg2], #1		@ load a char from arg2
   cmp	  tmp1, tmp2			@ compare tmp1 and tmp2
   bne 	  chk_set				@ check when not equal
   subs	  tmp3, #1				@ reduce the len for loop counter
   bne    loop					@ iterate till tmp3 is 0
   b      fn_return   			@ return from the function 
chk_set:
   bgt	  fn_return				@ return as the char of first string is greater
   sub    ret, #1				@ set ret to -1 
fn_return:
   pop    {pc}					@ restore and return

_storeResult:
   push   {lr}
   ldr    tmp1, =tst_greater		@ load the tst_greater memory
   str    ret, [tmp1, result_idx]	@ store the ret on tmp1+result_idx 
   pop    {pc}

exit:   
   .end