Inhospitable
A simple game of survival in a cold wasteland.

TODO
Features
* Play test distance between bunkers and starvation 
Fixes
* Prevent Player from starting inside an unwalkable position
* Add in more informative logging
* Adjust amount and placement of food/meds in a bunker

Log
8/5/15
-Started work on a spiral algorithim. The idea is that the game will choose a spot for players,bunkers,etc and check if its a valid start location. if not, will spiral around until it finds one.

-Finally got perlin to generate my small - medium pockets of impassible terrain. So, the secret was I needed to use a 3 dimensional noise object, and I had to multiply by 10 the x,y values before passing them to the noise object. This change broadened the range naturally without having to invoke a curve. I spent some time tweaking my perlin method and generating values in a csv, which I would then graph. I reached a point where I felt comfortable setting the range for snow within .4 - .7 My graph showed the edges of the values just going over those points. 

8/4/15
-I finally cracked the perlin noise algorithim and got it to generate. I had been working on this problem as far back as March or April before giving up on it. It doesnt work how I want it to yet, but it works. All I'm looking for is for it to do mostly snow with smatterings of impassible rock.

8/3/15
-Changed the color of snow to be black on white. The default color appears to be white on black. Discovered that changing a tile's color also changes its ascii value.

8/2/15
-Fixed the menu bug that would not redraw map until user input while also processing an enemy turn. Experimented with logging and saving. Decided that saving existed outside the scope of this game. This game is meant to be played in one sitting.

7/29/15
-Updated Menu so that the text fully displays, and there is also a help menu for instructions.

7/27/15
-Today I finished the code to make multiple monsters spawn with a certain % in each bunker. I also cleaned up terrain generation and monster item pickup code

7/26/15
-I figured out how to make n bunkers and n beacons randomly generate and not overlap. The next step is to play test the right size of the map, the right starvation count and the appropriate distance between bunkers. One thing I need to do before that is redo monster code so that the game will create and move n monsters.

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