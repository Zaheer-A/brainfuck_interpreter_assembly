.data

CELL: .skip 30000						# Setup an array of 30000 to reserve space for the cells.

.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
brainfuck:
	pushq %rbp
	movq %rsp, %rbp						# Setup the stack

	movq %rdi, %rsi
	movq $format_str, %rdi
	call printf
	movq $0, %rax

# *********************************************INSERT CODE **************************************************************************
	movq $0, %rdx				#  %rdx as our data pointer and initializing 
	movq $-1 , %rcx 			# %rcx is our counter to loop through the string in the file
	
nextChar:	
	incq %rcx				# Increment the counter
	movb (%rsi, %rcx, 1), %al		# get the next character from the string into register			
	cmpb $0, %al				# checking if the char (byte) is a zero byte (end of string)
	jne	loop1				# if it is not a zero byte, then we jump to our loop subruotine
	jmp endsub				# if it is a zero byte (end of string) we end our brainfuck interpreter.
	
	
 		
loop1:	
	plus:					# check if the character in %al is a plus operator
		movb $'+', %r8			# moving the '+' char for compare operation
		cmpb %al, %r8
		jne minus			# if it is not a '+' then go to the next check subroutine

		incb CELL(%rdx)			# increment the value in the cell that is currently being pointed to by %rdx
		jmp nextChar			# go back to nextChar to get the next character from the string

	minus:	
		movb $'-', %r8			# moving the '-' char for compare operation
		cmpb %al, %r8			
		jne pointer_up			# if it is not a '-' then go to the next check subroutine

		decb CELL(%rdx)			# decrement the value in the cell that is currently being pointed to by %rdx	 

		jmp nextChar			# go back to nextChar to get the next character from the string.

	pointer_up:
		movb $'>', %r8			# move the '>' char for compare operation
		cmpb %al, %r8			
		jne pointer_down		# if it is not a '>' then go to the next check subroutine

		inc %rdx			# increment the cell pointer to point to the next cell

		jmp nextChar			# go back to nextChar to get the next character from the string.

	pointer_down:
		movb $'<', %r8			# move the '<' char for compare operation
		cmpb %al, %r8			
		jne loop_open			# if it is not a '<' then go to the next check subroutine

		dec %rdx			# decrement the cell pointer to point to the previous cell

		jmp nextChar			# go back to nextChar to get the next character from the string.

	loop_open:
		movb $'[', %r8
		cmpb %al, %r8
		jne loop_close

		mov (%rsp, %rbx, 8), %rax
		cmp $0, %rax
		jne loop_open_nonzero












# ***********************************************************************************************************************************

endsub: 	movq %rbp, %rsp						# Clean up the stack
			popq %rbp
			ret
