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

countdown_setup:
	li t3, 2 	
	li t4, 0xFFFFFF
	li a7, 32
	li a0, 500
	j draw_five
	
draw_right:
	sw t4, (t0)
	addi t0, t0, 4
	sw t4, (t0)
	addi t0, t0, 4
	sw t4, (t0)
	ret
	
draw_left:
	sw t4, (t0)
	addi t0, t0, -4
	sw t4, (t0)
	addi t0, t0, -4
	sw t4, (t0)
	ret
	
draw_down:
	sw t4, (t0)
	addi t0, t0, 64
	sw t4, (t0)
	addi t0, t0, 64
	sw t4, (t0)
	ret
	
draw_up:
	sw t4, (t0)
	addi t0, t0, -64
	sw t4, (t0)
	addi t0, t0, -64
	sw t4, (t0)
	ret
	
draw_five:
	lw t0, initialize	#heap base address
	addi t0, t0, 160	#starting position
	jal draw_left
	jal draw_down
	jal draw_right
	jal draw_down
	jal draw_left
	ecall
	li t4, 0x000000		#for deleting the number
	addi t2, t2, 1		
	bne t2, t3, draw_five
	li t4, 0xFFFFFF
	li t2, 0
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
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_four
	li t4, 0xFFFFFF
	li t2, 0
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
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_three
	li t4, 0xFFFFFF
	li t2, 0
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
	li t4, 0x000000
	addi t2, t2, 1
	bne t2, t3, draw_two
	li t4, 0xFFFFFF
	li t2, 0
	j draw_one
	
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
		
	
exit_countdown:
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	lw t2, 16(sp)
	lw t3, 20(sp)
	addi sp, sp, 24
	
	jalr t6, 4
