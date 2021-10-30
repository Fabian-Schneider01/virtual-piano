.data
initialize:		
.word 0x10040000 #heap base address
.text

addi sp, sp, 16
sw a0, (sp)
sw a7, 4(sp)
sw t0, 8(sp)
sw t1, 12(sp)

countdown_setup:
	li t2, 2 	#loop counter
	li t1, 0xFFFFFF
	li a7, 32
	li a0, 500
	j draw_five
	
draw_right:
	sw t1, (t0)
	addi t0, t0, 4
	sw t1, (t0)
	addi t0, t0, 4
	sw t1, (t0)
	ret
	
draw_left:
	sw t1, (t0)
	addi t0, t0, -4
	sw t1, (t0)
	addi t0, t0, -4
	sw t1, (t0)
	ret
	
draw_down:
	sw t1, (t0)
	addi t0, t0, 64
	sw t1, (t0)
	addi t0, t0, 64
	sw t1, (t0)
	ret
	
draw_up:
	sw t1, (t0)
	addi t0, t0, -64
	sw t1, (t0)
	addi t0, t0, -64
	sw t1, (t0)
	ret
	
draw_five:
	lw t0, initialize
	addi t0, t0, 160
	jal draw_left
	jal draw_down
	jal draw_right
	jal draw_down
	jal draw_left
	ecall
	li t1, 0x000000
	addi t3, t3, 1
	bne t2, t3, draw_five
	li t1, 0xFFFFFF
	li t3, 0
	j draw_four
	
draw_four:
	lw t0, initialize
	addi t0, t0, 152
	jal draw_down
	jal draw_right
	jal draw_up
	jal draw_down
	jal draw_down
	ecall
	li t1, 0x000000
	addi t3, t3, 1
	bne t2, t3, draw_four
	li t1, 0xFFFFFF
	li t3, 0
	j draw_three
	
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
	li t1, 0x000000
	addi t3, t3, 1
	bne t2, t3, draw_three
	li t1, 0xFFFFFF
	li t3, 0
	j draw_two
	
draw_two:
	lw t0, initialize
	addi t0, t0, 152
	jal draw_right
	jal draw_down
	jal draw_left
	jal draw_down
	jal draw_right
	ecall
	li t1, 0x000000
	addi t3, t3, 1
	bne t2, t3, draw_two
	li t1, 0xFFFFFF
	li t3, 0
	j draw_one
	
draw_one:
	lw t0, initialize
	addi t0, t0, 160
	jal draw_down
	jal draw_down
	ecall
	li t1, 0x000000
	addi t3, t3, 1
	bne t2, t3, draw_one
	li t1, 0xFFFFFF
	li t3, 0
	j exit_countdown
		
	
exit_countdown:
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	addi sp, sp, 16
	addi zero, zero, 0
	jalr t6, 4

		
	