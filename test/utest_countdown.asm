#this test checks the draw methods of draw_countdown.asm
#first all numbers are drawn with only one color (not deleted afterwards) -> will look like an 8 in 7 digit display
#afterwards the numbers of draw_countdown.asm are being drawn
#when 5 second countdown is finished, the complete screen should be cleared 
#a1 = 1 if edges of countdown area is cleared, a1 = -1 if there are still white pixels in the edges of countdown area
.data
utest_initialize:		
.word 0x10040000 
.text

utest_setup:
	li s3, 1	
	li t4, 0xFFFFFF
	j utest_draw_five

#draw all numbers without deleting them -> let draw_countdown.asm delete them
utest_draw_five:
	lw t0, utest_initialize
	addi t0, t0, 160	
	jal draw_left
	jal draw_down
	jal draw_right
	jal draw_down
	jal draw_left
	j utest_draw_four
	
utest_draw_four:
	lw t0, utest_initialize
	addi t0, t0, 152
	jal draw_down
	jal draw_right
	jal draw_up
	jal draw_down
	jal draw_down

	j utest_draw_three
	
utest_draw_three:
	lw t0, utest_initialize
	addi t0, t0, 152
	jal draw_right
	jal draw_down
	jal draw_left
	jal draw_right
	jal draw_down
	jal draw_left

	j utest_draw_two
	
utest_draw_two:
	lw t0, utest_initialize
	addi t0, t0, 152
	jal draw_right
	jal draw_down
	jal draw_left
	jal draw_down
	jal draw_right

	j utest_draw_one
	
utest_draw_one:
	lw t0, utest_initialize
	addi t0, t0, 160
	jal draw_down
	jal draw_down
	

#call the countdown from draw_countdown.asm
jal s4, countdown_setup
	
#test if edges are cleared, as expected from draw_countdown.asm
call_numbes:
	la t0, utest_initialize
	addi t0, t0, 152
	lw t4, (t0)
	lw t0, utest_initialize
	bnez t4, utest_failed
	addi t0, t0, 160
	lw t4, (t0)
	bnez t4, utest_failed
	addi t0, t0, 416
	lw t4, (t0)
	bnez t4, utest_failed
	addi t0, t0, 408
	lw t4, (t0)
	bnez t4, utest_failed
	
#all edges are cleared -> success -> a1 = 1
utest_success:
	li a1, 1
	j exit_utest

#not all edges are cleard -> fail -> a1 = -1
utest_failed:
	li a1, -1
	j exit_utest
		
.include "../src/draw_countdown.asm"
	
exit_utest:
	li a7, 10
	ecall
