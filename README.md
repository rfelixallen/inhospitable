# inhospitable
a simple of survival in a cold wasteland

TODO for Extra Features
* Perlin noise map generation
* Random Bunker Generation
* Add in Color
* Add in Main Menu
** Make all entries visible
** Enter keyboard command in main window to return to menu
* Add in Save/Load 

Log
7/22/15
-Fixed combat :) Problem stemmed from poorly implimented symbcode class attributes.

7/21/15
-Built a janky menu for playing the game or quitting.
-I kinda half fixed combat. The monster can attack me, but I cant attack it the way I want. I added in a way to hit him so I could test combat. My best guess right now is that when the main game loop executes, the player code to attack either gets ignored, or is targeting the wrong thing. 

7/20/15
-Went on a trip and spent about 8 hours working on new code. On the productive side, I condensed the movement code, and reworked movement space checking. I can also now add more monsters! Less productive experiments include fiddling with color and making tiles into objects.

5/17/15
-I am very happy with the progress I have made with this. I feel that I finally have something I am ready to show people. This is not at all the final product, but I may shelve it for the time being so I can focus on new projects.

5/12/15
-I ran into a problem with how attacks work. For a demo, I hard coded in attacking rules against the monster, but the code directly attacks the single monster. I need to find a way to attack any monster. Ideally, mvwinch would return the object variable, but Ruby doesnt work like that.

5/8/15
-Added in code for picking up food and medkits, and then for using them. Code isnt great, and I opted not to try and fix a problem. For example, right now when the player moves, the game checks what the next tile is. Right now, if it detects a monster, it attacks the only monster that was created. I'll need away to distinguish from any monster.

5/7/15
-Successfully implimented the radio! The radio will produce the message of the closet beacon, and can choose from n beacons. Once I start playtesting, I can fiddle with the distances.

5/6/15
-Working on new ways to define buildings and draw them to the map. Right now, it seems like I need to make a class that defines my structures, and then initialize the class once in main.rb. Then, I can call any structure I want.
-Opted to stick with one type of bunker that actually draws. The next challenge is determining randomly if they are inhabited.

Copyright 2015 Robert Allen