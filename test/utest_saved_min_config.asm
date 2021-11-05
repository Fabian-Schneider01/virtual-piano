#generated code with minimal position of volume slider, duration slider and first element of instrument menu
#deleted melody -> not relevant for this test
.text
utest_min:
initialize_min:
li a7, 33
li a1, 0
li a2, 0
li a3, 0
li t0, 0 
li t1, -4

main_min:
bge t1, t0, play_melody_min
j exit_min
play_melody_min:
lw a0, 0(a4)
addi t0, t0, 4
addi a4, a4, 4
ecall 
j main_min

exit_min:
addi zero, zero, 0
ret