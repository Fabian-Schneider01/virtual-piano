.text
initialize:
li a7, 33	#MidiOutSync Sycall (Load the service number in register a7)
li a1, 500	#Duration (Optional)
li a2, 18	#Instrument (Optional)
li a3, 80	#Volume (Optional)

main:
bnez a0, playSound	#If a Keybutton from the tool has been pressed, Issue the ecall instruction 
j main

playSound:	#Plays the Sound
ecall
j main

