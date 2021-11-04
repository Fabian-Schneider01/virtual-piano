#a 5 second countdown will be printed to prepare the user for the game 

.data
initialize:		
.word 0x10040000 #heap base address
.text

addi sp, sp, -24
sw a0, (sp)
sw a7, 4(sp)
sw t0, 8(sp)
sw t1, 12(sp)
sw t2, 16(sp)
sw t3, 20(sp)

#numbers will be drawn in white
countdown_setup:
	#max value of loop -> first draw white, afterwards delete by drawing same number in black
	li t3, 2 	
	#load white color
	li t4, 0xFFFFFF
	#sleep sycall -> 1 sec between each number
	li a7, 32
	li a0, 500
	j draw_five
	
#draws three pixels to the right
draw_right:
	sw t4, (t0)
	addi t0, t0, 4
	sw t4, (t0)
	addi t0, t0, 4
	sw t4, (t0)
	ret
	
#draws three pixels to the left
draw_left:
	sw t4, (t0)
	addi t0, t0, -4
	sw t4, (t0)
	addi t0, t0, -4
	sw t4, (t0)
	ret
	
#draws three pixels down
draw_down:
	sw t4, (t0)
	addi t0, t0, 64
	sw t4, (t0)
	addi t0, t0, 64
	sw t4, (t0)
	ret
	
#draws three pixels up
draw_up:
	sw t4, (t0)
	addi t0, t0, -64
	sw t4, (t0)
	addi t0, t0, -64
	sw t4, (t0)
	ret
	
draw_five:
	#heap base address
	lw t0, initialize
	#starting position to begin drawing the number	
	addi t0, t0, 160
	#path to draw number	
	jal draw_left
	jal draw_down
	jal draw_right
	jal draw_down
	jal draw_left
	ecall
	#load black to delete the number
	li t4, 0x000000		
	addi t2, t2, 1		
	bne t2, t3, draw_five
	#load white and prepare for drawing the next number
	li t4, 0xFFFFFF
	li t2, 0
	j draw_four
	
#same procedure as drawing number 5
draw_four:
	lw t0, initialize
	addi t0, t0, 152
	jal draw_down
	jal draw_right
	jal draw_up
	jal draw_down
	jal draw_down
	ecall
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_four
	li t4, 0xFFFFFF
	li t2, 0
	j draw_three
	
#same procedure as drawing number 4
draw_three:
	lw t0, initialize
	addi t0, t0, 152
	jal draw_right
	jal draw_down
	jal draw_left
	jal draw_right
	jal draw_down
	jal draw_left
	ecall
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_three
	li t4, 0xFFFFFF
	li t2, 0
	j draw_two
	
#same procedure as drawing number 5
draw_two:
	lw t0, initialize
	addi t0, t0, 152
	jal draw_right
	jal draw_down
	jal draw_left
	jal draw_down
	jal draw_right
	ecall
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_two
	li t4, 0xFFFFFF
	li t2, 0
	j draw_one
	
#same procedure as drawing number 5
draw_one:
	lw t0, initialize
	addi t0, t0, 160
	jal draw_down
	jal draw_down
	ecall
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_one
	li t4, 0xFFFFFF
	li t2, 0
	j exit_countdown
		
#exit countdown and jump back to main for starting the actual game
exit_countdown:
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	lw t2, 16(sp)
	lw t3, 20(sp)
	addi sp, sp, 24
	
	jalr t6, 4
