# inhospitable
a simple of survival in a cold wasteland

TODO
* Dynamic map generation
* Populate bunker with random items and enemies

Log
5/8/15
-Added in code for picking up food and medkits, and then for using them. Code isnt great, and I opted not to try and fix a problem. For example, right now when the player moves, the game checks what the next tile is. Right now, if it detects a monster, it attacks the only monster that was created. I'll need away to distinguish from any monster.

5/7/15
-Successfully implimented the radio! The radio will produce the message of the closet beacon, and can choose from n beacons. Once I start playtesting, I can fiddle with the distances.

5/6/15
-Working on new ways to define buildings and draw them to the map. Right now, it seems like I need to make a class that defines my structures, and then initialize the class once in main.rb. Then, I can call any structure I want.
-Opted to stick with one type of bunker that actually draws. The next challenge is determining randomly if they are inhabited.