#first phase: color pieces dropping down (remember the sequence)
#second phase: reprocedure the correct sequence by pressing the piano keys in the right order 

.data
#heap base address
init:		
.word	0x10040000 
#!has to contain 5 pitches / 5 elements to remember!
song_easy:
.word 64 69 60 62 67 
#!has to contain 10 pitches / 10 elements to remember!
song_medium: 
.word 64 67 64 69 67 62 64 71 
#!has to contain 15 pitches / 15 elements to remember!
song_difficult: 
.word 65 60 62 60 69 67 65 69 65 64 65 
#every pitch is assigned to a color
colors:
.word 0xFF0000 0xFF9E00 0xFFFB00 0x90FF00 0x05FF00 0x00FFDE 0x0099FF 0x001AFF 0x9000FF 0xF800FF 0xFF007B 0xFF0000 

.text 

#draws the top row with every color piece
draw_top:			
	lw t0, init		
	la t1, colors 		
	li t2, 0		
	li t3, 12
	#move one pixel to the right and place a different color		
	draw_top_loop:
		lw t4, (t1)	
		sw t4, (t0)	
		addi t0, t0, 4
		addi t1, t1, 4
		addi t2, t2, 1
		bne t3, t2, draw_top_loop

begin:
	lw t0, init 
	#score stored in a6 - hit = +10 points, miss = -5 points
	li a6, 0 	
 	#preparing for loading the song address depending on chosen difficulty in a4
 	li t1, 1
 	#a4 holds the song difficulty (set in song_difficulties)
	beq a4, t1, load_easy
	li t1, 2
	beq a4, t1, load_medium
	li t1, 3
	beq a4, t1, load_difficult
	
#loads song address, depending on difficulty (easy stores less values than difficult)  
load_easy:
	la a5, song_easy
	j play_song_easy

load_medium:
	la a5, song_medium
	j play_song_medium

load_difficult:
	la a5, song_difficult
	j play_song_difficult
	
#needed for returning to the correct difficulty and max. counter value after a color piece dropped to the bottom
song_decider:
	li t1, 1
	beq a4, t1, play_song_easy
	li t1, 2
	beq a4, t1, play_song_medium
	li t1, 3
	beq a4, t1, play_song_difficult
	
#t3 limits the pointer from moving too far
#moving the pieces by calling play_song
#after all pieces have been moved play_init starts interaction
play_song_easy:
	#t2 has to be loaded after it was stored before each color piece is moving down
	lw t2, (sp)	
	li t3, 5	
	bne t2, t3, play_song
	j play_init
	
play_song_medium:
	lw t2, (sp)
	li t3, 8	
	bne t2, t3, play_song
	j play_init
	
play_song_difficult:
	lw t2, (sp)
	li t3, 11	
	bne t2, t3, play_song
	j play_init
	
#a5 contains song address and moves one value forward with each iteration
play_song:
	lw t4, 0(a5)	
	addi a5, a5, 4	
	addi t2, t2, 1
	
	#counter t2 need to be stored for label before
	addi sp, sp, -8
	sw t2, (sp)		
	
	#checks if current pitch value of song array is equal
	#then jumps to the label for placing correct colored piece
	prep_c:				
		li t1, 60
		beq t1, t4, place_c	
	prep_cs:
		li t1, 61
		beq t1, t4, place_cs 
	prep_d:
		li t1, 62
		beq t1, t4, place_d
	prep_ds:
		li t1, 63
		beq t1, t4, place_ds
	prep_e:
		li t1, 64
		beq t1, t4, place_e
	prep_f:
		li t1, 65
		beq t1, t4, place_f
	prep_fs:
		li t1, 66
		beq t1, t4, place_fs
	prep_g:
		li t1, 67
		beq t1, t4,place_g
	prep_gs:
		li t1, 68
		beq t1, t4, place_gs
	prep_a:
		li t1, 69
		beq t1, t4, place_a
	prep_as:
		li t1, 70
		beq t1, t4, place_as
	prep_b:
		li t1, 71
		beq t1, t4, place_b
	
#base address of heap will be loaded 
#offset is written in t0 for moving one pixel to the right (horizontally)
#t4 contains the color which describes the pitch value -> will be placed on display through t0
#jumping to move_piece_down label for moving one pixel down (vertically)
place_c:
	lw t0, init	
	li t3, 8	
	li t2, 0 	
	addi t0, t0, 0	
	li t4, 0xFF0000	
	sw t4, 0(t0)	
	j choose_speed_difficulty	

place_cs:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 2
	li t4, 0xFF9E00	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_d:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 8
	li t4, 0xFFFB00	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_ds:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 12
	li t4, 0x90FF00	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_e:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 16
	li t4, 0x05FF00	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_f:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 20
	li t4, 0x00FFDE	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_fs:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 24
	li t4, 0x0099FF	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_g:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 28
	li t4, 0x001AFF	
	sw t4, 0(t0)
	j choose_speed_difficulty
	
place_gs:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 32
	li t4, 0x9000FF	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_a:
	lw t0, init
	li t3, 8 
	li t2, 0 
	addi t0, t0, 36
	li t4, 0xF800FF	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_as:
	lw t0, init
	li t3, 8 
	li t2, 0
	addi t0, t0, 40
	li t4, 0xFF007B	
	sw t4, 0(t0)
	j choose_speed_difficulty

place_b:
	lw t0, init
	li t3, 8
	li t2, 0
	addi t0, t0, 44 
	li t4, 0xFF0000 
	sw t4, 0(t0)
	j choose_speed_difficulty
	
#sets the speed for color pieces moving down -> depending on the difficulty (stored in a4)
choose_speed_difficulty:
	li t1, 1
	beq a4, t1, draw_speed_easy
	li t1, 2
	beq a4, t1, draw_speed_medium
	li t1, 3
	beq a4, t1, draw_speed_difficult

draw_speed_easy:
	li a0, 350
	j move_piece_down
draw_speed_medium:
	li a0, 250
	j move_piece_down
draw_speed_difficult:
	li a0, 100
	j move_piece_down

move_piece_down:
	#color value in t5 moved in t4, needed to delete pixel afterwards	
	mv t5, t4
	#offset of 64 places the piece to the pixel below (vertically)	
	addi t0, t0, 64	
	sw t5, (t0)
	#value for sleep ecall, a0 already set in draw_speed_... label
	li a7, 32
	ecall		
	#delete pixel before
	li t5, 0
	sw t5, (t0)
	addi t2, t2, 1	
	#while not hitting the bottom border of display
	bne t2, t3, move_piece_down	
	#chooses the next color block moving down
	j song_decider

#sets up the part in which the user takes action by pressing the piano keys in the right order
play_init:
	li a7, 33
	#has to be zero, otherwise score will be lowered wrongly
	li a0, 0
	#if the right key was pressed, a piano plays the pitch with a duration of 350, volume of 80 and the piano instrument	
	li a1, 350	
	li a2, 0	
	li a3, 80
	
	li t2, 0
	li t1, 1
	#loads the correct difficulty array for comparing with the values played by the user 
	beq t1, a4, play_easy
	li t1, 2
	beq t1, a4, play_medium
	li t1, 3
	beq t1, a4, play_difficult
	
	j draw_pieces_exit
	
	#loads the correct difficulty array and waits for input by user 
	play_easy:
		la a5, song_easy
		j key_listen
	play_medium:
		la a5, song_medium
		j key_listen
	play_difficult:
		la a5, song_difficult
		j key_listen
	
	
#loads the first pitch and listens if the user pressed a key (endless loop until a key was pressed)
key_listen:
	lw t5, (a5)
	#if key was pressed
	bnez a0, key_pressed
	#if key wasn't pressed -> endless loop
	bne t3, t2, key_listen
	#all correct keys have been pressed -> show the players score
	j draw_pieces_exit 
	
#checks wether the pressed key was correct or not -> comparing to difficulty array
key_pressed:
	beq t5, a0, key_correct		
	bne t5, a0, key_wrong
	
	j key_listen
	
#the correct key/pitch was pressed 
key_correct:
	#play the pitch 
	ecall
	#draw a green bar on the right side
	jal draw_hit
	#for jumping back to the next key listener 
	li a0, 0
	#go one address further in difficulty array
	addi a5, a5, 4
	#add 10 points to the player score
	addi a6, a6, 10		
	#counts up until all correct keys have been pressed
	addi t2, t2, 1
	#jump back to listen or to exit and show score
	j key_listen

#the incorrect key has been pressed
key_wrong:
	# draw a red bar on the right side and play the missed sound effect
	jal draw_miss
	#for jumping back to the next key listener 
	li a0, 0
	#subtract 5 points of the players score
	addi a6, a6, -5		
	#jump back to listen or to exit and show score
	j key_listen
	
draw_hit:
	addi sp, sp, -24
	sw a0, (sp)
	sw a7, 4(sp)
	sw t0, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	
	#green color for the bar on the right
	li t4, 0x04FF06 
	#draw 8 green pixels from top to bottom
	li t3, 8
	
	#reset counter and load display address
	li t2, 0
	lw t0, init
	#address of the display to begin drawing
	addi t0, t0, 60
	
	#draw bar (vertically) by placing pixels in one column/below eachother
	draw_hit_loop:
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, draw_hit_loop
		
	#let the bar appear for 250 ms
	li a7, 32
	li a0, 250
	ecall
	
	#load black for deleting the green bar
	li t4, 0x000000
	li t2, 0
	lw t0, init
	addi t0, t0, 60
	
	#same as draw_hit_loop -> this time draw bar black
	delete_hit_loop:
		li t4, 0 
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, delete_hit_loop
	
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 24
	
	ret

draw_miss: 
	addi sp, sp, -36
	sw a0, (sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a7, 16(sp)
	sw t0, 20(sp)
	sw t2, 24(sp)
	sw t3, 28(sp)
	sw t4, 32(sp)
	
	#miss sound effect
	sound_miss:
	li a7, 33
	li a0, 59
	li a1, 435
	li a2, 104
	li a3, 15
	ecall
	
	#load red color to draw red bar on the right side
	#same procedure as draw_hit, just with color read instead of green
	li t4, 0xFF0000 
	li t3, 8
	
	li t2, 0
	lw t0, init
	addi t0, t0, 60 
	
	draw_miss_loop:
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, draw_miss_loop
		
	li a7, 32
	li a0, 250
	ecall
	
	li t4, 0x000000
	li t2, 0
	lw t0, init
	addi t0, t0, 60
	
	delete_miss_loop:
		li t4, 0 
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, delete_miss_loop
	
	lw a0, (sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw a3, 12(sp)
	lw a7, 16(sp)
	lw t0, 20(sp)
	lw t2, 24(sp)
	lw t3, 28(sp)
	lw t4, 32(sp)
	addi sp, sp, 36
	
	ret

#jump back to main program and finally show the score
draw_pieces_exit:
	jalr t6, 4
