.data
init:		
.word	0x10040000 #heap base address
song_easy: #always contains 10 pitches => test reason only 1
.word 60
song_medium: #always contains 20 pitches => test reason only 2
.word 65 65
song_difficult: #always conatins 30 pitches => test reason only 3
.word 70 70 70

colors:
.word 0xFF0000 0xFF9E00 0xFFFB00 0x90FF00 0x05FF00 0x00FFDE 0x0099FF 0x001AFF 0x9000FF 0xF800FF 0xFF007B 0xFF0000 #color values

.text 
########prepare game########

draw_top:			#draw the row with colorpiece	
	lw t0, init		#load heap base address
	la t1, colors 		#load color array address
	li t2, 0		#counter max
	li t3, 12		#counter
	draw_top_loop:
		lw t4, (t1)	#load elements of color array
		sw t4, (t0)	#print color pieces
		addi t0, t0, 4
		addi t1, t1, 4
		addi t2, t2, 1
		
		bne t3, t2, draw_top_loop

start:
	lw t0, init 	#load heap base address
	li a4, 3	####test!!####
	li a6, 0 	#score
 	#load song array address
 	li t1, 1
	beq a4, t1, load_easy
	li t1, 2
	beq a4, t1, load_medium
	li t1, 3
	beq a4, t1, load_difficult
	li s2, 0 #counter for play_song_decider
	
#a4 song address
#a4 not needed for sycall
load_easy:
	la a5, song_easy
	j play_song_easy

load_medium:
	la a5, song_medium
	j play_song_medium

load_difficult:
	la a5, song_difficult
	j play_song_difficult
	
########pitch value cases########

switch.start:
	switch.c:
		lw t0, init	#load heap base address
		li t3, 8	#counter max
		li t2, 0 	#counter
		addi t0, t0, 0	#column address
		li t4, 0xFF0000	#load colorvalue immediately
		sw t4, 0(t0)	#print to display
		j move.down	#make colorpiece move down

	switch.cs:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 4
		li t4, 0xFF9E00	
		sw t4, 0(t0)
		j move.down

	switch.d:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 8
		li t4, 0xFFFB00	
		sw t4, 0(t0)
		j move.down

	switch.ds:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 12
		li t4, 0x90FF00	
		sw t4, 0(t0)
		j move.down

	switch.e:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 16
		li t4, 0x05FF00	
		sw t4, 0(t0)
		j move.down

	switch.f:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 20
		li t4, 0x00FFDE	
		sw t4, 0(t0)
		j move.down

	switch.fs:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 24
		li t4, 0x0099FF	
		sw t4, 0(t0)
		j move.down

	switch.g:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 28
		li t4, 0x001AFF	
		sw t4, 0(t0)
		j move.down
	
	switch.gs:
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 32
		li t4, 0x9000FF	
		sw t4, 0(t0)
		j move.down

	switch.a:
		lw t0, init
		lw t0, init
		li t3, 8 
		li t2, 0 
		addi t0, t0, 36
		li t4, 0xF800FF	
		sw t4, 0(t0)
		j move.down

	switch.as:
		lw t0, init
		li t3, 8 
		li t2, 0
		addi t0, t0, 40
		li t4, 0xFF007B	
		sw t4, 0(t0)
		j move.down

	switch.b:
		lw t0, init
		li t3, 8
		li t2, 0
		addi t0, t0, 44 
		li t4, 0xFF0000 
		sw t4, 0(t0)
		j move.down

########move color pieces down########

move.down:	
	mv t5, t4	#t5 tmp color
	addi t0, t0, 64	#address of display +64 to move one pice down (vertically)
	sw t5, (t0)
		
	li a7, 32	#value for sleep ecall
	li a0, 100	#speed of moving pieces
	ecall		#sleep ecall
	#delete pixel before
	li t5, 0
	sw t5, (t0)
	addi t2, t2, 1		#counter
	
	bne t2, t3, move.down	#while <= bottom of display
	j play_song_decider
	
########decide color and position depending on pitch########
play_song_decider:
	li t1, 1
	beq a4, t1, play_song_easy
	li t1, 2
	beq a4, t1, play_song_medium
	li t1, 3
	beq a4, t1, play_song_difficult
	
play_song_easy:
	lw t2, (sp)	#load counter for this function
	li t3, 1	#max counter ONLY TEST => HAS TO BE CHANGED TO 10
	bne t2, t3, play.song
	j play.init
	
play_song_medium:
	lw t2, (sp)
	li t3, 2	#max counter ONLY TEST => HAS TO BE CHANGED TO 20
	bne t2, t3, play.song
	j play.init
	
play_song_difficult:
	lw t2, (sp)
	li t3, 3	#max counter ONLY TEST => HAS TO BE CHANGED TO 30
	bne t2, t3, play.song
	j play.init
	
play.song:

	lw t1, 0(a5)	#load song address
	addi a5, a5, 4	#one position further with each iteration
	addi t2, t2, 1
	
	addi sp, sp, -8
	sw t2, (sp)	#store counter	
	case.c:				
		li t5, 60
		beq t1, t5, switch.c	#compare song address and pitch 
	case.cs:
		li t5, 61
		beq t1, t5, switch.cs 
	case.d:
		li t5, 62
		beq t1, t5, switch.d
	case.ds:
		li t5, 63
		beq t1, t5, switch.ds
	case.e:
		li t5, 64
		beq t1, t5, switch.e
	case.f:
		li t5, 65
		beq t1, t5, switch.f
	case.fs:
		li t5, 66
		beq t1, t5, switch.fs
	case.g:
		li t5, 67
		beq t1, t5, switch.g
	case.gs:
		li t5, 68
		beq t1, t5, switch.gs
	case.a:
		li t5, 69
		beq t1, t5, switch.a
	case.as:
		li t5, 70
		beq t1, t5, switch.as
	case.b:
		li t5, 71
		beq t1, t5, switch.b

play.init:
	li a7, 33
	li a0, 0	
	li a1, 350	
	li a2, 0	
	li a3, 80
	
	li t2, 0
	li t1, 1
	beq t1, a4, play_easy
	li t1, 2
	beq t1, a4, play_medium
	li t1, 3
	beq t1, a4, play_difficult
	
	j program.exit
	
	play_easy:
		la a5, song_easy
		
		j play_check
	play_medium:
		la a5, song_medium
		j play_check
	play_difficult:
		la a5, song_difficult
		j play_check
	
	
play_check:

	lw t5, (a5)
	bnez a0, play.cond_if
	
	bne t3, t2, play_check
	j program.exit 
	

play.cond_if:
	beq t5, a0, key.correct		#if a keybutton from the tool has been pressed, issue the ecall instruction 
	bne t5, a0, key.wrong
	
	j play_check
	
key.correct:
	jal draw.hit
	ecall
	
	li a0, 0
	addi a5, a5, 4
	addi a6, a6, 10		#add 10 points
	addi t2, t2, 1
	j play_check

key.wrong:

	li a0, 0
	addi a6, a6, -5		#subtract 5 points
	jal draw.miss
	
	j play_check
	
draw.hit:
	addi sp, sp, -24
	sw a0, (sp)
	sw a7, 4(sp)
	sw t0, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)

	li t4, 0x04FF06 
	li t3, 12 
	
	li t2, 0
	lw t0, init
	addi t0, t0, 56 
	
	draw.hit.loop:
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, draw.hit.loop
		
	li a7, 32
	li a0, 250
	ecall
	
	li t4, 0x000000
	li t2, 0
	lw t0, init
	addi t0, t0, 56
	
	delete.hit.loop:
		li t4, 0 
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, delete.hit.loop
	
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 24
	
	ret

draw.miss: 
	addi sp, sp, -24
	sw a0, (sp)
	sw a7, 4(sp)
	sw t0, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)

	li t4, 0x04FF06 
	li t3, 12 
	
	li t2, 0
	lw t0, init
	addi t0, t0, 56 
	
	draw.miss.loop:
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 4
		addi t0, t0, 64
		bne t3, t2, draw.miss.loop
		
	li a7, 32
	li a0, 250
	ecall
	
	li t4, 0x000000
	li t2, 0
	lw t0, init
	addi t0, t0, 56
	
	delete.miss.loop:
		li t4, 0 
		sw t4, (t0)
		addi t2, t2, 1
		addi t0, t0, 64
		bne t3, t2, delete.miss.loop
	
	lw a0, (sp)
	lw a7, 4(sp)
	lw t0, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 24
	
	ret

program.exit:
	jalr t6, 4
