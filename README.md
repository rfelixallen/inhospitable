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


Copyright 2015 Robert Allen
