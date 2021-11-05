#generated code with maximum position of volume slider, duration slider and last element of instrument menu
#deleted melody -> not relevant for this test -> this is not the test itself! will be called by utest_max_min_config.asm
.text
utest_max:
initialize_max:
li a7, 33
li a1, 3000
li a2, 112
li a3, 127
li t0, 0 
li t1, -4

main_max:
bge t1, t0, play_melody_max
j exit_max 

play_melody_max:
lw a0, 0(a4) 
addi t0, t0, 4 
addi a4, a4, 4 
ecall 
j main_max

exit_max:
addi zero, zero, 0
ret
