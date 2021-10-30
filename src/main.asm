.data
ask.quit: .string "\nquit? (Yes = 1 / N = 0): "
ask.quit.wrong: .string "input wrong - type either Y or N"
show.score.player_1: .string "score of player1: "
show.socer.player_2: .string "score of player 2: "
show.max_score.easy: .string " /100"
show.max_score.medium: .string " /200"
show.max_score.difficult: .string " /300"
show.high_score: "current highscore: "

.text
main:
	
	jal set.difficulty	#difficulty stored in a1
	li t0, 1
	jal t6, countdown_setup
	li t6, 0
	jal t6, draw.top
	j show_score
	
show_score:
	li a7, 4
	la a0, show.score.player_1
	ecall
	li a7, 1
	li a0, 0
	mv a0, a6
	ecall
	
	li t1, 1
	beq s1, t1, easy_highscore
	li t1, 2
	beq s1, t1, medium_highscore
	li t1, 3
	beq s1, t1, difficult_highscore
	
	j program_exit

easy_highscore:
	li a7, 4
	la a0, show.max_score.easy
	ecall
	j program_exit
medium_highscore:
	li a7, 4
	la a0, show.max_score.medium
	ecall
	j program_exit
	
difficult_highscore:
	li a7, 4
	la a0, show.max_score.difficult
	ecall
	j program_exit
	
program_exit:
	addi zero, zero, 0
	la a0, ask.quit
	li a7, 4
	ecall
	
	li a0, 0
	li a7, 5
	ecall 
	addi zero, zero, 0
	
.include "song_difficulties.asm"
.include "numbers.asm"
.include "draw.asm"
