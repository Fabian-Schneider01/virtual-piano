.data

init:		
.word	0x10040000 #heap base address
song:
.word 60 61 62 63 60 70 70 63 69 #song pitches
colors:
.word 0xFF0000 0xFF9E00 0xFFFB00 0x90FF00 0x05FF00 0x00FFDE 0x0099FF 0x001AFF 0x9000FF 0xF800FF 0xFF007B 0xFF0000 #color values

.text 

########prepare game########

draw.top:			#draw the row with colorpiece
	li t3, 12		#counter max
	li t4, 0		#counter	
	lw t0, init		#load heap base address
	la a1, colors 		#load color array address
	draw.loop:
		lw t1, (a1)	#load elements of color array
		sw t1, (t0)	#print color piecees
		addi t4, t4, 1
		addi t0, t0, 4
		addi a1, a1, 4
		bne t3, t4, draw.loop

main:
	lw t0, init 	#load heap base address
	li a6, 0 	#score
	la a5, song 	#load song array address
	j play.song 	#move down pieces depending on song
	
########pitch value cases########

switch.start:
	switch.c:
		lw t0, init	#load heap base address
		li t3, 8	#counter max
		li t4, 0 	#counter
		addi t0, t0, 0	#column address
		li t1, 0xFF0000	#load colorvalue immediately
		sw t1, 0(t0)	#print to display
		j move.down	#make colorpiece move down

	switch.cs:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 4
		li t1, 0xFF9E00	
		sw t1, 0(t0)
		j move.down

	switch.d:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 8
		li t1, 0xFFFB00	
		sw t1, 0(t0)
		j move.down

	switch.ds:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 12
		li t1, 0x90FF00	
		sw t1, 0(t0)
		j move.down

	switch.e:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 16
		li t1, 0x05FF00	
		sw t1, 0(t0)
		j move.down

	switch.f:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 20
		li t1, 0x00FFDE	
		sw t1, 0(t0)
		j move.down

	switch.fs:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 24
		li t1, 0x0099FF	
		sw t1, 0(t0)
		j move.down

	switch.g:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 28
		li t1, 0x001AFF	
		sw t1, 0(t0)
		j move.down
	
	switch.gs:
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 32
		li t1, 0x9000FF	
		sw t1, 0(t0)
		j move.down

	switch.a:
		lw t0, init
		lw t0, init
		li t3, 8 
		li t4, 0 
		addi t0, t0, 36
		li t1, 0xF800FF	
		sw t1, 0(t0)
		j move.down

	switch.as:
		lw t0, init
		li t3, 8 
		li t4, 0
		addi t0, t0, 40
		li t1, 0xFF007B	
		sw t1, 0(t0)
		j move.down

	switch.b:
		lw t0, init
		li t3, 8
		li t4, 0
		addi t0, t0, 44 
		li t1, 0xFF0000 
		sw t1, 0(t0)
		j move.down

########move color pieces down########

move.down:	
	addi t2, t1, 0	
	addi t0, t0, 64	#address of display +64 to move one pice down (vertically)
	sw t2, (t0)
	
	li a0, 1
	addi sp, sp, -8	#prepare sleep ecall
	sw a0, (sp)	
	sw a7, 4(sp)	
	li a7, 32	#value for sleep ecall
	li a0, 100	#speed of moving pieces
	ecall		#sleep ecall
	lw a0, (sp)	#load previous member ecall
	lw a7, (sp)	#load previous ecall value
	addi sp, sp, 8
	#delete pixel before
	li t2, 0
	sw t2, (t0)
	addi t4, t4, 1		#counter
	bne t4, t3, move.down	#while <= bottom of display
	j play.song
	
########decide color and position depending on pitch########
play.song:

	lw t1, 0(a5)	#load song address
	addi a5, a5, 4	#one position further with each iteration
	
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
	
	j play.init

		
	
draw.hit:
	addi sp, sp, -28
	sw a0, (sp)
	sw t2, 4(sp)
	sw t3, 8(sp)
	sw t4, 12(sp)
	sw a5, 16(sp)
	sw t0, 20(sp)
	sw a7, 24(sp)

	li t2, 0x04FF06 
	li t3, 12 
	
	li t4, 0
	lw t0, init
	addi t0, t0, 56 
	
	draw_loop_hit:
		
		sw t2, (t0)
		addi t4, t4, 1
		addi t0, t0, 64
		bne t3, t4, draw_loop_hit
		
	li a7, 32
	li a0, 250
	ecall
	
	li t4, 0
	lw t0, init
	addi t0, t0, 56
	
	delete_loop_hit:
		li t2, 0 
		sw t2, (t0)
		addi t4, t4, 1
		addi t0, t0, 64
		bne t3, t4, delete_loop_hit
	
	lw a0, (sp)
	lw t2, 4(sp)
	lw t3, 8(sp)
	lw t4, 12(sp)
	lw a5, 16(sp)
	lw t0, 20(sp)
	lw a7, 24(sp)
	addi sp, sp, 24
	
	ret

draw.miss: 
	addi sp, sp, -28
	sw a0, (sp)
	sw t2, 4(sp)
	sw t3, 8(sp)
	sw t4, 12(sp)
	sw a5, 16(sp)
	sw t0, 20(sp)
	sw a7, 24(sp)

	li t2, 0xFF0000
	li t3, 12 
	
	li t4, 0
	lw t0, init
	addi t0, t0, 60
	
	draw.miss.loop:
		sw t2, (t0)
		addi t4, t4, 1
		addi t0, t0, 4
		addi t0, t0, 60
		bne t3, t4, draw.miss.loop
		
	li a7, 32
	li a0, 250
	ecall
	
	li t4, 0
	lw t0, init
	addi t0, t0, 60
	
	delete.miss.loop:
		li t2, 0 
		sw t2, (t0)
		addi t4, t4, 1
		addi t0, t0, 4
		addi t0, t0, 60
		bne t3, t4, delete.miss.loop
	
	lw a0, (sp)
	lw t2, 4(sp)
	lw t3, 8(sp)
	lw t4, 12(sp)
	lw a5, 16(sp)
	lw t0, 20(sp)
	lw a7, 24(sp)
	addi sp, sp, 24
	
	ret


program.nothing:
	addi zero, zero, 0

play.init:
	li a7, 33	
	li a1, 350	
	li a2, 0	
	li a3, 80
	la a5, song
	li a0, 0
	
play.check:
	lw t1, (a5)
	bnez a0, play.cond_if
	li t2, 0xFF0000 	#value of first address in next array
	bne t1, t2, play.check #run until next array section begins
	j program.exit 

play.cond_if:
	beq t1, a0, key.correct #if a keybutton from the tool has been pressed, issue the ecall instruction 
	bne t1, a0, key.wrong
	
	j play.check

key.wrong:

	li a0, 0
	addi a6, a6, -5
	jal draw.miss
	
	j play.check

key.correct:
	jal draw.hit
	ecall
	
	addi a5, a5, 4
	li a0, 0
	addi a6, a6, 10

	j play.check

program.exit:
	li a7, 1
	addi a0, a6, 0
	ecall
	addi zero, zero, 0
	
	
	
