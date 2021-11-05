# Virtual Piano

A RARS tool extension for playing a virtual piano with mini-game mode

## Authors

Fabian Schneider

## Demo Video

[![IMAGE ALT TEXT](http://img.youtube.com/vi/-h3eH4ubuno/0.jpg)](http://www.youtube.com/watch?v=-h3eH4ubuno "Video Title")

Replace -h3eH4ubuno in the this .md by your YT video

## Description
###Introduction
The project "Virtual Piano" was developed to offer RARS users the oppertunity to play a virtual piano as a tool included in RARS. 
In addition to the normal mode for making music, the virtual piano offers extra functionalities, which are listed below:

### Virtual Piano

1) adjust: volume, duration and select one from multiple instruments
2) record: after the record button is pressed, everything you played will be stored 
3) play: the play button lets you hear the melody you've played in an recording session
4) save: after finishing a recording session, the save button copies an automatically generated assembly code to your clipboard, which you can include in a new .asm file. In runtime the recorded melody will be played with the adjusted volume, duration and instrument
5) game: the game button colors your piano key buttons to a specific color, as a preparation for the mini-game
An in-depth paragraph about your project and overview of use.

##How to run
music mode: run src/tool/start.asm in RARS                            

game mode: run src/game.asm in RARS    

### Mini-Game Mode

##How to run
## Files
Describe the content of each file of your application: e.g.

src/tool/VirtualPiano.Java   # Main file of program

src/tool/start.asm # compiled version of main.c for RV32IM

src/main.asm # A specific feature called in main

test/saved.asm - test9.asm # 9 unit tests for featureA


## Test
Successful Unit Tests
![utest_screenshot_1](https://user-images.githubusercontent.com/81293687/140469724-cee143c6-4dda-4fcd-83f2-bab549457e64.jpg)
![utest_screenshot_2](https://user-images.githubusercontent.com/81293687/140469817-8f004696-bf07-45da-bb74-fc0ff71fcbd9.jpg)
