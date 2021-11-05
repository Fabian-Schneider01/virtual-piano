#if a piano key in the virtual piano is pressed, then the MidiOutSync Sycall is called
#you will hear a sound with the pitch you chose by pressing one of the piano keys
.text
initialize:
	#MidiOutSync Sycall (Load the service number in register a7)
	li a7, 33
	#duration (optional/can be set in runtime with Virtual Piano tool)
	li a1, 500	
	#instrument (optional/can be set in runtime with Virtual Piano tool)
	li a2, 0	
	#volume (optional/can be set in runtime with Virtual Piano tool)
	li a3, 80	

main:
	#if a key is pressed, the ecall gets called
	bnez a0, play_sound
	#no key was pressed, jump back to main and listen	
	j main

play_sound:	
	#sound is generated
	ecall
	#listen for the next key being pressed
	j main
