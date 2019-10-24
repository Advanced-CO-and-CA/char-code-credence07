/************************************************************************************
* file: substr_cs18m532.s                                                           *
* Assembly code to check whether the second string is a substring of the First one  *
************************************************************************************/

@ bss section
.bss


@ data section
.data
str_src:		.asciz "CS6620"
str_tstA:		.asciz "S5"
str_tstB:		.asciz "620"
str_tstC:		.asciz "6"

tst_present:	.word 0	@ Test A Substring position result
				.word 0 @ Test B Substring position result
				.word 0 @ Test C Substring position result

@ text section
.text

.global _substr				@ Function to check if the arg2 is substring of arg1 and return its position on arg1

@ members on function usage

arg1		.req r0 		@ argument1 for string 1
arg2 		.req r1			@ argument2 for string 2
ret			.req r2			@ return value of the function holding the index of the source arg1 where the substring is found
tmp1		.req r3			@ temp member for processing
tmp2 		.req r4			@ temp member for processing
tmp3		.req r5			@ temp member for processing
result_idx	.req r6			@ argument for test result index
first_idx   .req r7			@ first string index
second_idx	.req r8			@ second string index

.global _main

_main:
	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstA		@ get the address of str_tstA on arg2(r1)
	bl    _substr  				@ call to Function to find substr with link
	mov   result_idx, #0		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	
	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstB		@ get the address of str_tstB on arg2(r1)
	bl    _substr  				@ call to Function to find substr with link
	mov   result_idx, #4		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	
	ldr   arg1, =str_src		@ get the address of src_str on arg1(r0)
	ldr   arg2, =str_tstC		@ get the address of str_tstC on arg2(r1)
	bl    _substr  				@ call to Function to find substr with link
	mov   result_idx, #8		@ index to store the comparion result
	bl 	  _storeResult			@ call to function to store the ret to the index
	
	b 	  exit

_substr:
   push   {lr}						@ push the return address to stack
   mov 	  ret, #0					@ init ret with 0(substr index)
reset_loop:
   mov 	  first_idx, ret			@ Init the reference indexes 
   mov 	  second_idx, #0
   mov 	  ret, #0   
   ldrb   tmp2, [arg2, second_idx]	@ load a char from arg2
find_loop:
   ldrb   tmp1, [arg1, first_idx]	@ load a char from arg1
   add 	  first_idx, #1				@ increment the arg1 index
   cmp	  tmp1, #0					@ compare tmp1 to check for null
   beq	  finish					@ exit as reached the end of source string
   
   cmp	  tmp1, tmp2				@ compare char at the indexes on arg1 and arg2
   bne	  find_loop					@ Continue to compare the arg1 char with start of arg2
   mov 	  ret, first_idx			@ on match mov the current arg index to ret   
match_loop:
   add    second_idx, #1			@ continue the comparision 
   ldrb   tmp1, [arg1, first_idx]	@ get arg1 char at the index
   ldrb   tmp2, [arg2, second_idx]	@ get arg2 char at the index
   cmp 	  tmp2, #0					@ compare tmp2 to check for null
   beq	  finish					@ if null we got the match for substring 
   cmp    tmp1, tmp2				@ compare the chars of both string
   bne	  reset_loop				@ if not equal reset and continue comparision till arg1 end of string
   cmp	  tmp1, #0					@ check for arg1 EOS
   moveq  ret, #0					@ set ret to 0 as we reached arg1 eos and arg2 still has chars
   beq	  finish					@ exit as reached end of source string
   add    first_idx, #1				@ increment arg1 index
   b 	  match_loop				@ continue to check for match
finish:
   pop    {pc}						@ restore and return

_storeResult:
   push   {lr}
   ldr    tmp1, =tst_present		@ load the tst_greater memory
   str    ret, [tmp1, result_idx]	@ store the ret on tmp1+result_idx 
   pop    {pc}

exit:   
   .end