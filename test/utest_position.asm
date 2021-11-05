.text
#check if topbar existing and memory is filled with values
test_draw_top:
	la t0, init
	lw t4, (t0)
	beqz t4, utest_failed
	lw t4, 12(t0)
	beqz t4, utest_failed

#draw a sidebar. if the values are being reset (because of delete_hit_loop and delete_miss_loop)
#then the sidebars work as they should 
test_hit:
	jal draw_sidebar
	jal draw_hit
	lw t0, init
	addi t0, t0, 60 
	beqz t0, utest_failed
	
test_miss:
	jal draw_sidebar
	jal draw_miss
	lw t0, init
	addi t0, t0, 60
	beqz t0, utest_failed
	j utest_success
	
#draws the sidebar. draw_hit and draw_miss should delete it
draw_sidebar:
	li t4, 0x04FF06 
	li t3, 12 
	
	li t2, 0
	lw t0, init
	addi t0, t0, 60 
	
	draw_bar:
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, draw_bar
	ret
	
utest_failed:
	li a1, -1
	j utest_exit
	
#returns 1 in a1 for success
utest_success:
	li a1, 1
	j utest_exit

.include "../src/draw_pieces.asm"

utest_exit:
	li a7, 10
	ecall
