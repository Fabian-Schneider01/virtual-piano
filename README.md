# Virtual Piano

A RARS tool extension for playing a virtual piano with mini-game mode

## Authors

Fabian Schneider 
contact: inf20182@lehre.dhbw-stuttgart.de

## Presentation Video

[![IMAGE ALT TEXT](http://img.youtube.com/vi/eukcTmpCptg/0.jpg)](https://www.youtube.com/watch?v=eukcTmpCptg "Virtual Piano")

## Presentation
[Virtual Piano.pptx](https://github.com/Fabian-Schneider01/Virtual-Piano/files/7489061/Virtual.Piano.pptx)

## Description

### Introduction

The project "Virtual Piano" was developed to offer RARS users the oppertunity to play a virtual piano as a tool included in RARS. You'll be able to change values of the MidiOutSync Sycall in runtime leading to different sounds everytime you change something in the GUI. 
In addition to the normal mode for making music, the virtual piano offers multiple functionalities, which are listed in the `Virtual Piano` section. Besides playing the piano normally there is also an integrated mini-game mode which trains your brain by making you memorize a melody sequence (symbolized through colors). There are multiple difficulties  which you can choose from. How the game works and additional information are written in the `Mini-Game Mode` section.

## Virtual Piano
GUI of the Virtual Piano

![basic_virtual_piano](https://user-images.githubusercontent.com/81293687/140512151-ba5aa52b-e2ef-447d-b806-8cf9025b8b2f.jpg)

#### Description of the functionalities:
* `adjust:` volume, duration and select one from multiple instruments
* `record:` after the record button is pressed, everything you played will be stored in the .data-segment
* `reset:` the reset button will delete the recording you've made before
* `save:` after finishing a recording session, the save button copies an automatically generated assembly code to your clipboard, which you can include in a new .asm file. In runtime the recorded melody will be played with the adjusted volume, duration and instrument
* `play:` the play button lets you hear the melody you've played in an recording session
* `game:` the game button colors your piano key buttons to a specific color, as a preparation for the mini-game

### How to play

**There is no ideal way to play a piano. Try out different configurations in the GUI and play around with different instruments.**

### How to run
open `src/tool/start.asm` in RARS and execute                          
 
## Mini-Game Mode
![Mini-Game Umsetzung](https://user-images.githubusercontent.com/81293687/140580003-85e34c3e-61ae-4353-af74-1e2c7a1d816e.jpg)

## Setup
![setup_game](https://user-images.githubusercontent.com/81293687/140581464-cf2ed43b-c73f-4db8-b862-1c5fcdf5ad28.jpg)

* open the bitmap display and the virtual piano in the tool section
* press the game button in the virtual piano tool
* select 32 for `nit width in pixels` and `nit height in pixels`
* select 512 for `display width in pixels` and 256 for `display height in pixels`
* select `0x10040000(heap)` as the base address for the display

## How to play

* Run the program
* Select a difficulty by typing to the console `(easy = 1 / medium = 2 / difficult = 3)`
* Get ready in countdown phase
* You have to memorize the pattern of color pieces dropping down
* After all colored pieces dropped down, next step is to press the piano keys in the same sequence as the colored pieces dropped down
* If a green bar appears on the right, you pressed the correct key. A red bar appears if you pressed the wrong key
* After all correct keys have been pressed, your score will appear in the console
> INFO: If you want to change the melody for each difficulty, you're able to do so by changing pitch values in draw_pieces.asm. 
> Pay attention to not assign more values than written

## How to run

open `src/main.asm` in RARS and execute

## Files
Description of all files (rars extension, mini-game, unit tests)
### RARS extension files

* `src/tool/VirtualPiano.Java` # File for creating the virtual piano and let it appear in the tool section of RARS

* `src/tool/start.asm` # The correct assembly code for playing the virtual piano

* `src/tool/rars.jar` # Application, `JDK 17!!`

* `src/tool/rars.zip` # Contains all files and classes of the newest RARS version (including the Virtual Piano)

### Mini-Game files

* `src/main.asm` # Main class of mini-game (launches the game)

* `src/song_difficulties` # Sets the game difficulty (melody difficulty and movement speed of pixels)

* `src/draw_countdown.asm` # Draws a five second countdown before memorizig phase begins

* `src/draw_pieces.asm` # moves the pixels down and listens in second phase for a pressed keys by the user

### Unit Test files

* `test/utest_countdown.asm` # tests if the countdown appears at the correct position

* `test/utest_difficulties.asm` # tests if difficulty value is stored in correct register, after user set a difficulty

* `test/utest_highscore.asm` # tests if the correct highscore strings are printed (depending on difficulty)

* `test/utest_max_min_config.asm` # tests the maximum and minimum values of the Virtual Piano tool (for e.g value of slider when completely left)

* `test/utest_position.asm` # tests if green sidebar, red sidebar and colored topbar appears at correct position

* `test/utest_tool.asm` # tests if piano keys return the correct value and tests a random configuration of duration, volume and instrument

### Tested files (relevant for testing the saving function of the Virtual Piano)

* `test/utest_saved.asm` # contains a melody which will be compared with `test/utest_tool.asm`

* `test/utest_max_config.asm` # contains the maximum configuration values of the GUI and will be compared with `test/max_min_config.asm`

* `test/utest_min_config.asm` # contains the minimum configuration values of the GUI and will be compared with `test/max_min_config.asm`

## Tests
Successful Unit Tests
![utest_screenshot_1](https://user-images.githubusercontent.com/81293687/140469724-cee143c6-4dda-4fcd-83f2-bab549457e64.jpg)
![utest_screenshot_2](https://user-images.githubusercontent.com/81293687/140469817-8f004696-bf07-45da-bb74-fc0ff71fcbd9.jpg)
