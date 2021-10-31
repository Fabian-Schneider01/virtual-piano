#----------------------------------------
#SETUP FOR THE MINI-GAME (memory game)
#Open the bitmap bisplay and the virtual piano in the tool section
#Press the game button in the virtual piano tool
#Select 32 for "unit width in pixels" and "unit height in pixels"
#Select 512 for "display width in pixels" and 256 for "display height in pixels"
#Select 0x10040000(heap) for "base address for display
#----------------------------------------
#GAME INFORMATION (Rules of the memory game)
#1)Run the program
#2)Select a difficulty in the console (easy = 1 / medium = 2 / difficult = 3)
#3)Get ready in countdown phase
#4)You have to memorize the pattern of the color pieces dropping down
#5)After all colored pieces dropped down, you have to press the piano keys in the same sequence as the colored pieces dropped down
#6)If a green bar appears on the right, you pressed the correct key. A red bar appears if you pressed the wrong key
#7)After all correct keys have been pressed, your score will appear on in the console
#----------------------------------------
#USE OF REGISTERS THROUGHOUT THE PROGRAM
#a0: reserved for ecall
#a1: reserved for ecall
#a2: reserved for ecall
#a3: reserved for ecall
#a4: difficulty of minigame (selected by the user)
#a5: address of the song (depending on difficulty)
#a6: /
#a7: reserved for ecall
#t0: heap base address
#t1: used for comparisons 
#t2: counter for loops
#t3: maximum counter value for loops
#t4: loads each color value in color array
#t5: loads each pitch value in song array
#t6: used for jal
#----------------------------------------

.data
show.score.player_1: .string "score of player:  "
show.max_score.easy: .string " / 100"
show.max_score.medium: .string " / 200"
show.max_score.difficult: .string " / 300"

.text
main:
	#will be stored in a4
	jal set.difficulty
	jal t6, countdown_setup
	#reset linker
	li t6, 0
	jal t6, draw_top
	j show_score
	
show_score:
	#print to console
	li a7, 4
	la a0, show.score.player_1
	ecall
	
	#print final score to console
	li a7, 1
	li a0, 0
	mv a0, a6
	ecall
	
	#chooses the correct 
	li t1, 1
	beq a4, t1, easy_highscore
	li t1, 2
	beq a4, t1, medium_highscore
	li t1, 3
	beq a4, t1, difficult_highscore

#prints the maximum score string depending on difficulty
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
	
.include "song_difficulties.asm"
.include "draw_countdown.asm"
.include "draw_pieces.asm"

program_exit:
	addi zero, zero, 0
