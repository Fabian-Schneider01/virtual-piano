.data
ask.difficulty: .string "difficulty (easy = 1 / medium = 2 / difficult = 3): "
ask.difficulty.wrong: .string "input wrong - type either 1, 2 or 3"

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
	li a4, 1
	j exit_difficulties
	
set.difficulty.medium: 
	li a4, 2
	j exit_difficulties
	
set.difficulty.difficult:
	li s4, 3
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




	
	
