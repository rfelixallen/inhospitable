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

Current Feature Work
The theme of this feature work is user interface. I have 3 big features I want to introduce.

TODO
-Add dialogue windows

DONE
-Add colors
-Have dynamic screen resize (Incomplete)

NOTES
May 28 2016
-I finished work with colors, and they added some headaches. When you write characters with a color pair init, it changes the ascii number value of the characters. This is a little inconvenient based on how my game works. I have arrays that store the ascii character code for all walkable tiles, monsters and items. If I change the color, then it changes the ascii code of all that, and the arrays need to be updated with the new code. Moving forward, I just wouldnt use color in a game with how I currently have it working. However, a smarter way might be to print the map a different way, and give everything tags, and have the game logic function off of tags.

-Im almost done with my resizing window work. I wrote a functional window resizer last year, but it was with the curses library. I found a script online that does what I want it to do in Ncurses, and got it working in 2resize.rb. I put the number first to make it quicker to call on the command line. Now all I need to do is convert the logic of that script for my viewport window.

- I got window resizing to work with ruby Ncurses, but I dont know if it will work as intended. Window resizing works for both newwin, subwin and derwin, but on anything but newwin, it will leave artifacts that cant be easily cleared. I cant clear the game map and redraw it every time the terminal moves, because then I would need to redraw all the actors. Unfortunately, my Center method only works with derwin. I'm not sure how other games do it, so I may just stick with fixed widths for now.

Copyright 2015 Robert Allen