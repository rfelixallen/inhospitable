Inhospitable
A simple game of survival in a cold wasteland.

Installation
1. Clone the game locally to your computer. https://github.com/rfelixallen/inhospitable.git
2. In Terminal, cd into the directory and run 'bundle install'
3. Use Ruby version 2.1.5.

TODO
Features
* Play test distance between bunkers and starvation
* Ability to turn off beacons
* Add a clock to keep track of time
* Add temperature that changes during day and night
* Add z-levels
* Replace blank trail with quotes and colons for footprints
* Add snow to cover tracks
* End of the game (death or win) go back to main menu
* Explore weapons and armor
* Explore different windows for inventory, dialogue, logs, etc
* Put this in a Rails server to work on a website
* Ability to save and load
* Add Colors


Fixes
* Fix screen flashes
* Adjust amount and placement of food/meds in a bunker
* Fix border on viewp

Log
5/8/16
- Realized its way easier if I keep everything stored as an array, and then write class methods that export data as hashes. I had to revert all of my changes. That was kind of successful, but now I ran into the problem of properly generating everything from a json file. For bunkers, I learned that I only need to save the starting point for each bunker, and not all the positions.

5/7/16
- I have been fiddling with Json to save game information. Objects need to be saved as a hash before they can be saved in a json file. I had rejiggered my main, actors and terrain to rely on hash versions of walkable, actors and items instead of the array version they were saved as. While I can kinda save to Json, this has broken other methods that were still looking for arrays. Now I realize that you can create class methods that will pretty package your information into a format acceptable to json. So, instead of saving your data in an always ready json state, you save it in a data type that's easier to work with, and only convert it to hash/json when it needs to be.

I am at a cross roads where I either revert my hashes back to arrays, and make some new class methods for saving, or I need to fix the rest of my methods to take the new hashes that contain my game data.

Additionally, I need to rethink what data needs to be saved. At first I wanted to save everything: actors, bunkers, items, etc. Awhile later I realized that some data would be static, like walkable and items, and other data could be regenerated from a seed value, like bunkers and beacons. I redid bunker/beacon generation to generate from a seed, and to ignore making monsters if the game state was reloading data. This means that the only real information that needs to be saved are actor and item placement.

I explored moving forward with using all my variables as hashes. Its not too cumbersome to use, but I also need to store myplayer object as a hash, and update all that code. I tried invoking monster hash data and player array data, and remembered that in some methods I used the array invokation for both player and monsters. 

3/22/16
-I cleaned up some variables in Main.rb to make them more descriptive.

3/19/16
-I successfully exported Inhospitable's game map window to a save file. Restoring will be a bit more complicated, as Ill need to save additional information and instantiate that. Ill need to refactor how the game initializes so it can accomodate loaded variable or standard variables.

3/18/16
-I began experimenting with persistance, the fancy word for saving and reloading. I was able to dump a window and restore it using test files. The next test is to see if we can dump a game screen.

3/15/16
-And I am back! I plan on reviving this project and doing some more feature work. I miss coding, and I have ambitious roguelike plans. All I've done so far is update the feature list with some new ideas.

8/8/15
-Also changed monster code so that they dont pick up items.
-Fixed Monster hunting code using logging. The problem is that monsters were hunting if they were less than 5 on x OR y from the player. changed it to AND. Discovered bunkers generate out of bounds. 

8/6/15
- Made it such that monsters will only chase if they are within 5 spaces. HOWEVER, it seems that if one knows where you are, then they all know where you are and will run from miles away. They also wander like mosquitoes, and I want them to walk in straight lines for n spaces before determining a new direction.

-Finished a rough draft of working spiral code. The game will look at the players starting position, and then rotate them around in a spiral until it finds a valid starting position. I thought about doing this for bunkers, but all they really need is a border around them. I also updated the bunkers so that they had a 1 pixel buffer around them. This is to prevent them from becoming blocked off.

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