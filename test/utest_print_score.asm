#this test checks wether the right strings (depending on difficulty) are loaded to show the highscore 
#for testing, a score and difficulty will be loaded in the correct registers 
.text
init_utest:
	li s3, 1
test_easy_highscore:
	li a4, 1
	li a6, 25
	jal show_score
	
test_medium_highscore:
	li a4, 2
	li a6, 40
	jal show_score
	
test_difficult_highscore:
	li a4, 3
	li a6, 55
	jal show_score
	
test_exit:
	li a7, 10
	ecall
	
.include "../src/main.asm"
