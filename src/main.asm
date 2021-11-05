#SETUP FOR THE MINI-GAME (memory game)
#open the bitmap bisplay and the virtual piano in the tool section
#press the game button in the virtual piano tool
#select 32 for "unit width in pixels" and "unit height in pixels"
#select 512 for "display width in pixels" and 256 for "display height in pixels"
#select 0x10040000(heap) for "base address for display
########################
#GAME INFORMATION (Rules of the memory game)
#1)Run the program
#2)Select a difficulty by typing to the console (easy = 1 / medium = 2 / difficult = 3)
#3)Get ready in countdown phase
#4)You have to memorize the pattern of color pieces dropping down
#5)After all colored pieces dropped down, next step is to press the piano keys in the same sequence as the colored pieces dropped down
#6)If a green bar appears on the right, you pressed the correct key. A red bar appears if you pressed the wrong key
#7)After all correct keys have been pressed, your score will appear in the console
#INFO: If you want to change the melody for each difficulty, you're able to do so by changing pitch values in draw_pieces.asm. 
#Pay attention to not assign more values than written
##########################
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
#s2: compare value for returning to utest
#s3: compare vlaue for returning to utest
#########################
#strings which are printed to console to show the achieved score
.data
print_score: .string "score of player:  "
print_max_score_easy: .string " / 50"
print_max_score_medium: .string " / 80"
print_max_score_difficult: .string " / 110"

.text
main:
	#the user gets asked for the difficulty
	jal set_difficulty
	#5 seconds countdown before starting the game
	jal t6, countdown_setup
	#reset pointer
	li t6, 0
	#start the game session
	jal t6, draw_top
	#show score and end game
	j show_score
	
show_score:
	#print to console
	li a7, 4
	la a0, print_score
	ecall
	
	#print final score to console
	li a7, 1
	li a0, 0
	mv a0, a6
	ecall
	
#chooses the correct strong for each difficulty
score_condition:
	li t1, 1
	beq a4, t1, easy_highscore
	li t1, 2
	beq a4, t1, medium_highscore
	li t1, 3
	beq a4, t1, difficult_highscore

#prints the maximum score string depending on difficulty
easy_highscore:
	li a7, 4
	#print score before exiting game
	la a0, print_max_score_easy
	ecall
	j program_exit
	
medium_highscore:
	li a7, 4
	#print score before exiting game
	la a0, print_max_score_medium
	ecall
	j program_exit
	
difficult_highscore:
	li a7, 4
	#print score before exiting game
	la a0, print_max_score_difficult
	ecall
	j program_exit
	
.include "song_difficulties.asm"
.include "draw_countdown.asm"
.include "draw_pieces.asm"

#needed for accessing utest_highscore.asm
exit_utest:
	ret
#exit game
program_exit:
	li s2, 1
	beq s2, s3, exit_utest
	addi zero, zero, 0
	
