#testing correct selection of a song depending on difficulty 
#loading the songs and testing if there are values equal zero or not in range (not between 60 - 71)

.text
test_difficulty:
	li t2, 0
	j test_easy
	

test_easy:
	#amount of values in song array has to be five
	li t3, 5 
	la a5, song_easy
	lw t5, (a5)
	addi a5, a5, 4
	beq t5, zero, utest_failed
	
	#tests if values of easy difficulty is between 60 and 71 and not undefined
	li t1, 60
	blt t5, t1, utest_failed
	li t1, 72
	blt t1, t5, utest_failed
	addi t2, t2, 1
	bne t2, t3, test_easy
	li t2, 0
	
test_medium:
	#amount of values in song array has to be 8
	li t3, 8
	la a5, song_medium
	lw t5, (a5)
	addi a5, a5, 4
	beq t5, zero, utest_failed
	
	#tests if values of medium difficulty is between 60 and 71 and not undefined
	li t1, 60
	blt t5, t1, utest_failed
	li t1, 72
	blt t1, t5, utest_failed
	addi t2, t2, 1
	bne t2, t3, test_medium
	li t2, 0

test_difficult:
	#amount of values in song array has to be 11
	li t3, 11
	la a5, song_difficult
	lw t5, (a5)
	addi a5, a5, 4
	beq t5, zero, utest_failed
	
	#tests if values of difficult difficulty is between 60 and 71 and not undefined
	li t1, 60
	blt t5, t1, utest_failed
	li t1, 72
	blt t1, t5, utest_failed
	addi t2, t2, 1
	bne t2, t3, test_difficult
	j utest_success

	
utest_failed:
	li a1, -1
	j utest_exit
	
utest_success:
	li a1, 1
	j utest_exit
	
.include "../src/song_difficulties.asm"
.include "../src/draw_pieces.asm"

utest_exit:
	addi zero, zero, 0
