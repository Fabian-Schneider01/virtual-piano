.data
ask_difficulty: .string "difficulty (easy = 1 / medium = 2 / difficult = 3): "
ask_difficulty_wrong: .string "input wrong - type either 1, 2 or 3"

.text
addi sp, sp, -12
sw a0, (sp)
sw a7, 4(sp)
sw t0, 8(sp)

set_difficulty:
	la a0, ask_difficulty
	li a7, 4
	ecall
	
	li a7, 5
	ecall 

	li t1, 1
	beq a0, t1, set_difficulty_easy
	li t1, 2
	beq a0, t1, set_difficulty_medium
	li t1, 3
	beq a0, t1, set_difficulty_difficult
	j song_incorrect_input
	
set_difficulty_easy:
	li a4, 1
	j exit_difficulties
	
set_difficulty_medium: 
	li a4, 2
	j exit_difficulties
	
set_difficulty_difficult:
	li a4, 3
	j exit_difficulties

song_incorrect_input:
	la a0, ask_difficulty_wrong
	li a7, 4
	ecall
	j set_difficulty
	
exit_difficulties:
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	addi sp, sp, 12
	ret


	
	
