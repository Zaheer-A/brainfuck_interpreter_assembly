# netId: nmouman, Zaheer
# Nada Mouman , Ashma Zaheer
# 499630 , 5016142
.data
CELLS: .skip 30000

.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

brainfuck:
	pushq %rbp
	movq %rsp, %rbp
	pushq %r14
	pushq %rbx

	movq %rdi, %r8

	#movq %rdi, %rsi
	#movq $format_str, %rdi
	#call printf
	#movq $0, %rax



# ************************************************initialize the array CELLS*******************************************************
	movq $0, %rcx

loop:	movb $0, CELLS(%rcx)
		incq %rcx
		cmpq $30000, %rcx
		jl loop

# ************************************************Start of the program*******************************************************

	movq $0, %rcx							# set index of string to 0
	movq $0, %rdx							# set datapointer to 0 for CELLS
	movq $0, %r9							# set the number of brackets to 0
	# (%r8, %rcx,1) is accessing the next character

mainloop:	cmpb $'+', (%r8, %rcx,1)		# check if + is the current character in the string
			je plus							# if it is, go to the plus subroutine

			cmpb $'-', (%r8, %rcx,1)		# check if - is the current character in the string
			je minus						# if it is, go to the minus subroutine

			cmpb $'[', (%r8, %rcx,1)		# check if [ is the current character in the string
			je bracket_open					# if it is, go to the loop open bracket subroutine

			cmpb $']', (%r8, %rcx,1)		# check if ] is the current character in the string
			je bracket_close				# if it is, go to the loop end bracket subroutine

			cmpb $'>', (%r8, %rcx,1)		# check if > is the current character in the string
			je pointer_up					# if it is, go to the next data pointer subroutine

			cmpb $'<', (%r8, %rcx,1)		# check if < is the current character we got from the string
			je pointer_down					# if it is, go to the previous data pointer subroutine


			cmpb $'.', (%r8, %rcx,1)		# check if . is the current character in the string
			je print						# if it is go to the print subroutine

			cmpb $',', (%r8, %rcx,1)		# check if , is the current character in the string
			je read							# if it is, go to the read subroutine

			jmp nextChar						# jump to nextChar
								# ignore characters not commands

# *********************************************************************************************************************

plus: 	incb CELLS(%rdx)					# incrememt the selected cell's value
		jmp nextChar							# jump to nextChar to get the next character if there is one

# *********************************************************************************************************************

minus: 	decb CELLS(%rdx)					# decrement the selected cell's value
		jmp nextChar							# jump to nextChar to get the next character if there is one

# **********************************************************************************************************************

pointer_up:	incq %rdx						# increment the data pointer to point to the next cell's location
			jmp nextChar						# jump to nextChar to get the next character if there is one

# **********************************************************************************************************************

pointer_down:	decq %rdx					# decrement the data pointer to point to the previous cell's locations
				jmp nextChar					# jump to nextChar to get the next character if there is one

# **************************************************LOOPS***************************************************************

bracket_open:	cmpb $0, CELLS(%rdx)		# check if the loop counter is zero already
				jne nextChar					# if not, jump to nextChar to get the next charcter
				incq %rcx					# increment the index of the string to get next character if loop counter is zero

while:	cmpq $0, %r9						# check if the number of brackets is zero
		jg insideloop						# if the numbet of brackets is greater than zero then jump inside the loop
		cmpb $']', (%r8, %rcx,1)			# if it is zero, check if the next character is the ending loop symbol ]
		jne insideloop						# if it is not ], we want to jump inside the loop
		jmp nextChar							# otherwise the loop is comepleted and we can jump to nextChar to get the next character if there is one

insideloop:	cmpb $'[', (%r8, %rcx,1)		# check is the next character is [
			je ifcode						# if it is, jump to the ifcode
			cmpb $']', (%r8, %rcx,1)		# otherwise check if the character is a ]
			je elsecode						# if it is, we jump to the elsecode
			incq %rcx						# increment the index of the string to get the next character
			jmp while						# jump back to while

ifcode:	incq %r9							# increment the number of brackets in %r9 as we encountered a [
		incq %rcx							# increment the index 
		jmp while							# jump back to the while loop

elsecode:	decq %r9						# decrement the number of brackets in %r9
			incq %rcx						# increment the index
			jmp while						# jump back to the while loop

# *****************************************************************************************9*********************************

bracket_close:	cmpb $0, CELLS(%rdx)		# check if the loop counter is zero already
				je nextChar					# if it is, jukmp to nextChar and get the next character if there is one
				decq %rcx					# decrement the index

while1:	cmpq $0, %r9						# check if the number of brackets is zero
		jg insideloop1						# if the numbet of brackets is greater than zero then jump inside the loop
		cmpb $'[', (%r8, %rcx,1)			# if it is zero, check if the next character is the ending loop symbol [
		jne insideloop1						# if it is not [, we want to jump inside the loop
		jmp endbracketclose					# otherwise jump to endbracketclose 

insideloop1:	cmpb $']', (%r8, %rcx,1)	# check is the next character is ]
				je ifcode1					# if it is, jump to the ifcode
				cmpb $'[', (%r8, %rcx,1)	# otherwise check if the character is a [
				je elsecode1				# if it is, we jump to the elsecode
				decq %rcx					# decrement the index of the string to get the next character
				jmp while1					# jump back to while

ifcode1:	incq %r9						# increment the number of brackets in %r9 as we encountered a [
			decq %rcx						# decrement the index 
			jmp while1						# jump back to the while loop

elsecode1:	decq %r9						# decrement the number of brackets in %r9
			decq %rcx						# decrement the index 
			jmp while1						# jump back to the while loop

endbracketclose:	decq %rcx				
					jmp nextChar

# ***************************************************************************************************************************

print:	mov CELLS(%rdx), %al				# get the decimal value in the current cell and move it to %al
		push %rax							# push %rax onto the stack 
		call putchar						# use the library to call putchar which will write a single character to stdout
		jmp nextChar						# after printing, jump to nextChar to get the next character from the string

# *****************************************************************************************************************************

read:	call getchar						# we will call getchar from the library if we want to read a character
		mov %al, CELLS(%rdx)				# the character read from the user input is transferred into the selected cell
		jmp nextChar						# jump to nextChar to get the next character if there is one

# *****************************************************************************************************************************

nextChar:	incq %rcx						# increment the index of the string
			cmpb $0, (%r8, %rcx,1)			# check if it isn;t a zero byte (end of string)
			jne mainloop					# if it isn't a zero byte, jump to mainloop again with the next character
			jmp endsub						# jump to endsub if you got a zero byte as we are done now




# **************************************************End of subroutine**********************************************************
endsub:	popq %rbx							# clean
		popq %r14							# up
		movq %rbp, %rsp						# the
		popq %rbp							# stack!
		ret
