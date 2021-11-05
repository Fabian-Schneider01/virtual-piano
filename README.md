# Virtual Piano

A RARS tool extension for playing a virtual piano with mini-game mode

## Authors

Fabian Schneider

## Presentation Video

[![IMAGE ALT TEXT](http://img.youtube.com/vi/eukcTmpCptg/0.jpg)](https://www.youtube.com/watch?v=eukcTmpCptg "Virtual Piano")

## Description

### Introduction

The project "Virtual Piano" was developed to offer RARS users the oppertunity to play a virtual piano as a tool included in RARS.  
In addition to the normal mode for making music, the virtual piano offers multiple functionalities, which are listed below. Besides playing the piano normally there is also an integrated mini-game mode which trains your brain by making you memorize a melody sequence. There are multiple difficulties from which you can choose. How the game works and additional information are written further down.

### Virtual Piano
GUI of the Virtual Piano:

![basic_virtual_piano](https://user-images.githubusercontent.com/81293687/140512151-ba5aa52b-e2ef-447d-b806-8cf9025b8b2f.jpg)

#### Description of the functionalities:
1) adjust: volume, duration and select one from multiple instruments
2) record: after the record button is pressed, everything you played will be stored 
3) reset: the reset button will delete the recording you've made before
4) save: after finishing a recording session, the save button copies an automatically generated assembly code to your clipboard, which you can include in a new .asm file. In runtime the recorded melody will be played with the adjusted volume, duration and instrument
5) play: the play button lets you hear the melody you've played in an recording session
6) game: the game button colors your piano key buttons to a specific color, as a preparation for the mini-game
An in-depth paragraph about your project and overview of use.

### How to play


### How to run
open src/tool/start.asm in RARS and execute                          
 
### Mini-Game Mode
![Mini-Game Umsetzung](https://user-images.githubusercontent.com/81293687/140580003-85e34c3e-61ae-4353-af74-1e2c7a1d816e.jpg)

## How to run

open src/main.asm in RARS and execute

## Files
Description of all files (rars extension, mini-game, unit tests)
### RARS extension files

src/tool/VirtualPiano.Java # File for creating the virtual piano and let it appear in the tool section of RARS

src/tool/start.asm # The correct assembly code for playing the virtual piano

src/tool/rars.jar # Application, JDK 17!!!

src/tool/rars.zip # Contains all files and classes of the newest RARS version

### Mini-Game files

src/main.asm # Main class of mini-game (launches the game)

src/song_difficulties # Sets the game difficulty (melody difficulty and movement speed of pixels)

src/draw_countdown.asm # Draws a five second countdown before memorizig phase begins

src/draw_pieces.asm # moves the pixels down and listens in second phase for the pressed keys by the user

### Unit Test files

test/utest_countdown.asm # tests if the countdown appears at the correct position

test/utest_difficulties.asm # tests if difficulty value is stored in correct register, after user set a difficulty

test/utest_highscore.asm # tests if the correct highscore strings are printed (depending on difficulty)

test/utest_max_min_config.asm # tests the maximum and minimum values of the Virtual Piano tool (for e.g value of slider when completely left)

test/utest_position.asm # tests if green sidebar, red sidebar and colored topbar appears at correct position

test/utest_tool.asm # tests if piano keys return the correct value and tests a random configuration of duration, volume and instrument

### Tested files (relevant for testing the saving function of the Virtual Piano)

test/utest_saved.asm

test/utest_max_config.asm

test/utest_min_config.asm

## Test
Successful Unit Tests
![utest_screenshot_1](https://user-images.githubusercontent.com/81293687/140469724-cee143c6-4dda-4fcd-83f2-bab549457e64.jpg)
![utest_screenshot_2](https://user-images.githubusercontent.com/81293687/140469817-8f004696-bf07-45da-bb74-fc0ff71fcbd9.jpg)
