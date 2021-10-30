.data
ask.difficulty: .string "difficulty (easy = 1 / medium = 2 / difficult = 3): "
ask.difficulty.wrong: .string "input wrong - type either 1, 2 or 3"
song.easy: .word 65 64
song.medium: .word 65
song.difficult: .word 70

#a1 = song address

.text

addi sp, sp, -16
sw a0, (sp)
sw a7, 4(sp)
sw t0, 8(sp)

set.difficulty:
	la a0, ask.difficulty
	li a7, 4
	ecall
	
	li a7, 5
	ecall 

	li t0, 1
	beq a0, t0, set.difficulty.easy
	li t0, 2
	beq a0, t0, set.difficulty.medium
	li t0, 3
	beq a0, t0, set.difficulty.difficult
	j song_incorrect_input
	
set.difficulty.easy:
	li s1, 1
	la a1, song.easy 
	j exit_difficulties
	
set.difficulty.medium: 
	li s1, 2
	la a1, song.medium
	j exit_difficulties
	
set.difficulty.difficult:
	li s1, 3
	la a1, song.difficult
	j exit_difficulties

song_incorrect_input:
	la a0, ask.difficulty.wrong
	li a7, 4
	ecall
	j set.difficulty
	
exit_difficulties:
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	addi sp, sp, 16
	ret




	
	
