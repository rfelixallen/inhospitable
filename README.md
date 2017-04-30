Inhospitable
A simple game of survival in a cold wasteland.


Installation
OSX and Linux Instructions
Windows is not currently supported

Requires Ruby 2.1.5+

1. Open Terminal and clone the game locally to your computer:
git clone https://github.com/rfelixallen/inhospitable.git
2. Change directories and install all the gem dependancies.
cd inhospitable && bundle install
3. Play the game!
ruby main.br

How to Play
You are alone and hungry in a cold wasteland populated by bunkers. In order to survive, you must find each bunker and take a token. When you collect all the tokens, the game ends. Bunkers have food and medkits and maybe monsters.

You can move with the Arrow keys or WASD. Spacebar passes time without moving.
Walking onto food, medkits and tokens adds them to your inventory.
To attack a monster, walk into it. 
To deactivate a bunker's radio, walk into the 'A' icon.
To heal yourself, press the 'm' key.
To eat food, press the 'f' key.

TODO
- Refactor Actors, Walkable, Items, Beacons into class variables
- Consolidate extra methods into a videogame object
- Fix bunker generation bug. Found a bunker that generated off the map

Log
4/29/17
- Wanted to get back into coding, so I picked up where I left off 11 months ago. The last branch I made was to try and clean up my code. I realized that I had created global methods for like, everything. I wanted to clean up my code and put all the global methods into happy little classes. Each method would get a home. I kinda punked out in the middle of that due to, like, life. Anyway, I think I'm upish to speed nowish. There is a bit of work to do to rehouse all the global methods. In doing so, I broke some core features in the game. I dont think the player can get hurt, and they cant actually pick up items. This has to do with rehousing methods.
- Specifically, it looks like I had changed Item generation. Before, I was printing 'm' and 'f' and the game would see the symbicode for that letter and decide what type of item it was. Now, the game recognizes the symbicode only as a walkable tile, but not as an item. I think I have to overhaul how items work before it will show up.
-Also, I have some vague memory that the whole reason I was redoing classes was to cut down on these godawful methods that are like check_this(1,2,3,4,5,6,7,8,9,0).

Copyright 2015 Robert Allen
