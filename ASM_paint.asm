# Noah jett Paint program for TIM ISA, hardware 256
# 4/24/2019
# Button: 0-4, toggle, right, left, down, up
# set tick rate to 32 or higher for buttons to be responsive
setup:
	add $1, $zero, $zero	# $1 is the cursor, offset
	addi $2, $zero, 64	# $2 is base address of data memory
	addi $3, $zero, 1		# $3 set to 1 for toggle
	
storeBoard:
	sb $zero, $2, $1	# set dmem base + cursor = 0
	beq $1, $2, clearOne  # if the cursor is 64, done
	addi $1, $1, 1	# increment by one
	beq $zero, $zero, storeBoard	# loop
	
clearOne:
    add $1, $zero, $zero	# reset cursor from initial setup
    beq $zero, $zero, main
	
main:
	add $4, $zero, $zero
	andi $4, $input, 2		# set 4 to 1 if moveRight is 1
	addi $5, $zero, 2
	beq $4, $5, moveRight	# if 4 is 1, j to moveRight
	
	andi $4, $input, 4		# set 4 to 1 if moveLeft is 1
	addi $5, $zero, 4
	beq $4, $5, moveLeft	# if 4 is 1, j to moveLeft
	
	andi $4, $input, 8		# set 4 to 1 if moveDown is 1
	addi $5, $zero, 8
	beq $4, $5, moveDown	# if 4 is 1, j to moveDown
	
	andi $4, $input, 16		# set 4 to 1 if moveUp is 1
	addi $5, $zero, 16
	beq $4, $5, moveUp		# if 4 is 1, j to moveUp
	
	andi $4, $input, 1		# set $4 to 1 if toggle is 1
	beq $4, $3, toggle		# if $4 is 1, jump to toggle
	
	
	beq $zero, $zero, main	# loop to beginning
	
moveRight:
	add $4, $zero, $zero	# clear 4
	addi $4, $2, -1			# set 4 to 63
	beq $1, $4, loopLeft    # if we are in the last output spot, go back to beginning
	addi $1, $1, 1			# add one to cursor/offset
	add $input, $zero, $zero
	beq $zero, $zero, main	# jump back to main

loopLeft:
	add $1, $zero, $zero	# move cursor back to first space
	add $4, $zero, $zero	# clear 4
	beq $zero, $zero, main
	
moveLeft:
	beq $1, $zero, loopRight
	addi $1, $1, -1			# subtract one from cursor/offset
	add $4, $zero, $zero	# clear 4
	add $input, $zero, $zero
	beq $zero, $zero, main

loopRight:
	add $4, $zero, $zero	# clear 4
	addi $4, $zero, 63		# set 4 to last space in output
	add $1, $zero, $4		# set cursor to 63
	beq $zero, $zero, main
moveDown:
	addi $5, $zero, 56
	slt $6, $1, $5			# if cursor < 55, it is not in the bottom row
	beq $6, $zero, loopBackUp # if cursor is > 55, it's in the bottom row
	addi $1, $1, 8			# if cursor not in bottom row, add 8
	add $4, $zero, $zero	# clear 4
	add $5, $zero, $zero	# clear 5
	add $6, $zero, $zero	# clear 6
	add $input, $zero, $zero
	beq $zero, $zero, main	# j back to main
	
loopBackUp:
	addi $1, $1, -56		# if in bottom row, loop back up 7 rows
	add $4, $zero, $zero	# clear 4
	add $input, $zero, $zero
	beq $zero, $zero, main	# j back to main
	
moveUp:
	addi $5, $zero, 8		# set 5 to 8 for comparison
	slt $6, $1, $5			# if cursor is < 8, it is in the top row, set 6 to 1
	beq $6, $3, loopDown	# if in top row, loop down to bottom
	addi $1, $1, -8			# add 8 to cursor pos. to move up one row
	add $4, $zero, $zero	# clear 4
	add $5, $zero, $zero	# clear 5
	add $6, $zero, $zero	# clear 6
	add $input, $zero, $zero
	beq $zero, $zero, main	# j back to main
	
loopDown:
	addi $1, $1, 56			# if in top row, add 56 to get to bottom
	add $4, $zero, $zero	# clear 4
	add $input, $zero, $zero
	beq $zero, $zero, main
toggle:
	add $6, $zero, $zero	# clear 6
	lb $6, $1, $2			# see what is in memory at cursor loc + data base address
	beq $6, $zero, setOne	# if it is zero, set to one
	sb $zero, $1, $zero		# else set, output to zero
	sb $zero, $1, $2		# update memory board to zero
	add $6, $zero, $zero	# clear $4
	add $input, $zero, $zero
	beq $zero, $zero, main  # jump back to main
setOne:
	sb $3, $1, $zero			# set (base address + offset) = 1 in output
	sb $3, $1, $2			# set output board to 1
	add $input, $zero, $zero
	beq $zero, $zero, main	# jump back to main
	
done: