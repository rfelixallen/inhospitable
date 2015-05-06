require_relative 'library'
require 'ncurses'
include Ncurses

##################################################################################
# TODO                                                                           #
#   *Refactor existing code, use header files                                    #
#   *Refactor character and monster class to be children of new Actor class      #
                                                                #
##################################################################################
# tests                                                                          #
##################################################################################
test_library
test_ui
test_terrain
test_actors

#################################################################################
# Initialize                                                                    #
#################################################################################

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

sd_cols = []                # Standard Screen column aka y
sd_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,sd_cols,sd_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.

# Welcome Screen
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Welcome to Move!")
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2 + 1, sd_lines[0] / 2, "rows = #{sd_cols[0]}, rows = #{sd_lines[0]}")
Ncurses.refresh             # Refresh window to display new text
Ncurses.getch               # Wait for user input
Ncurses.clear               # Clear the screen once player is ready to proceed
Ncurses.refresh             # Refresh window to display cleared screen

# Instantiate Windows
# For each window, define lines,cols variables and work with those instead of direct numbers
# Demo game uses 4 windows: Field (aka game map), Viewport (aka what the player sees), Console and side HUD.
field_lines = 100
field_cols = 100
view_lines = field_lines / 4
view_cols = field_cols / 4
hud_lines = view_lines
hud_cols = 15
console_lines = 3
console_cols = view_cols + hud_cols

field = Ncurses.newwin(field_lines, field_cols, 0, 0)
viewp = Ncurses.derwin(field,view_lines, view_cols, 0, 0) # Must not exceed size of terminal or else crash
console = Ncurses.newwin(console_lines, console_cols, view_lines, 0) 
hud = Ncurses.newwin(hud_lines, hud_cols, 0, view_lines) 

# Draw map
# Ncurses uses the ascii decimal value of characters for input
# Included are 3 different map generation methods. Only one should be used.
draw_map(field)         # Draws a simple map with one terrain type
#generate_random(field) # Draws a map with x random characters, randomly chosen for each pixel.
building(field,10,10)   # Adds a building to map. It overlays anything underneath it

# Define Actors, Items and Terrain
actors = []         # Array will contain ascii decimal value of actor symbols 
items = [36]        # Array contains ascii decimal value of all items on ground
walkable = [32,126] # Array contains ascii decimal value of all walkable terrain

# Setup Actors
field_max_lines = []
field_max_cols = []
Ncurses.getmaxyx(field,field_max_cols,field_max_lines)   # Get Max Y,X of Field
player_start_lines = (field_max_lines[0] / 4)
player_start_cols = (field_max_cols[0] / 4)

# Create Player Character
p = Character.new(symb: '@', xlines: player_start_lines, ycols: player_start_cols, hp: 9) # Begin player in top, right corner
actors << p.symb.ord                                            # Add player symbol to array of actor symbols
Ncurses.mvwaddstr(field, p.xlines, p.ycols, "#{p.symb}")        # Draw layer to map
center(viewp,field,p.xlines,p.ycols)                            # Center map on player

# Create Monster
m = Character.new(symb: 'M', xlines: player_start_cols + view_cols, ycols: player_start_lines + view_lines, hp: 3) # Begin Monster near player, but out of sight
actors << m.symb.ord                                                    # Add player symbol to array of actor symbols
Ncurses.mvwaddstr(field, m.xlines, m.ycols, "#{m.symb}")                # Draw Monster to map
Ncurses.wrefresh(viewp) # Update viewport with all previous changes
message(console,actors)

# Set up Console
borders(console)                            # Add borders to the console
#Ncurses.mvwaddstr(console, 1, 2, "Hello!")  # Add a test message to confirm console works
Ncurses.wrefresh(console)                   # Refresh console window with message

# Set up HUD (Heads-Up-Display)
# Ideally, HUD will be updated automatically, and not by hand.
borders(hud)                                
Ncurses.mvwaddstr(hud, 1, 1, "The Game")
Ncurses.mvwaddstr(hud, 2, 1, "Time: 16:04")
Ncurses.mvwaddstr(hud, 3, 1, "Temp: 16 F")
Ncurses.mvwaddstr(hud, 4, 1, "HP: #{p.hp}")
Ncurses.mvwaddstr(hud, 5, 1, "Inventory:")
Ncurses.mvwaddstr(hud, 6, 1, "  -Club")
Ncurses.mvwaddstr(hud, 7, 1, "  -Flashlight")
Ncurses.wrefresh(hud)
#################################################################################
# Game Loop                                                                     #
#################################################################################

direction_steps = 0
counter = 0   
dice_roll = false

while p.hp > 0  # While Player hit points are above 0, keep playing
  input = Ncurses.getch
  case input
    when KEY_UP, 119 # Move Up
      check = check_movement(field,p.xlines - 1,p.ycols,walkable,items,actors)
        if check == 1      
          move_character_x(field,p,-1)
        elsif check == 2
          attack(m)
        elsif check == 3
          Ncurses.mvwaddstr(hud, 8, 1, "  -Money")
          Ncurses.wrefresh(hud)
          move_character_x(field,p,-1)
        else # No valid move          
          nil
        end      
      center(viewp,field,p.xlines,p.ycols)      
    when KEY_DOWN, 115 # Move Down
      check = check_movement(field,p.xlines + 1,p.ycols,walkable,items,actors)      
        if check == 1      
          move_character_x(field,p,1)
        elsif check == 2
          attack(m)
        elsif check == 3
          Ncurses.mvwaddstr(hud, 8, 1, "  -Money")
          Ncurses.wrefresh(hud)
          move_character_x(field,p,1)
        else # No valid move
          nil
        end      
      center(viewp,field,p.xlines,p.ycols)      
    when KEY_RIGHT, 100 # Move Right 
      check = check_movement(field,p.xlines,p.ycols + 1,walkable,items,actors)      
        if check == 1      
          move_character_y(field,p,1)          
        elsif check == 2
          attack(m)          
        elsif check == 3
          Ncurses.mvwaddstr(hud, 8, 1, "  -Money")
          Ncurses.wrefresh(hud)
          move_character_y(field,p,1)          
        else # No valid move
          nil
        end      
      center(viewp,field,p.xlines,p.ycols)      
  when KEY_LEFT, 97 # Move Left   
      check = check_movement(field,p.xlines,p.ycols - 1,walkable,items,actors)      
        if check == 1      
          move_character_y(field,p,-1)          
        elsif check == 2
          attack(m)        
        elsif check == 3
          Ncurses.mvwaddstr(hud, 8, 1, "  -Money")
          Ncurses.wrefresh(hud)
          move_character_y(field,p,-1)          
        else # No valid move
          nil
        end      
      center(viewp,field,p.xlines,p.ycols)      
    when KEY_F2, 113, 81 # Quit Game with F2, q or Q
      break
    else
      Ncurses.flash           # Flash screen if undefined input selected
      message(console,"Move not valid")  # Display ascii decimal number of selected input
      Ncurses.wrefresh(console) 
    end

  # Monster Move
  if m.hp <= 0
    Ncurses.mvwaddstr(field, m.xlines, m.ycols, "X") # Turn into dead body
    Ncurses.wrefresh(viewp)
  else
    distance_from_player = [(p.xlines - m.xlines).abs,(p.ycols - m.ycols).abs] # Get positive value of distance between monster and player
    if distance_from_player[0] < view_lines / 2 or distance_from_player[1] < view_cols / 2 # if the monster is visible, chase player
      message(console,"MONSTER HUNTS YOU!")  # Troubleshooting message for testing
      mode_hunt(field, m, p, walkable, items, actors)
    else # If player is not visible, wander around
      if counter <= direction_steps
        if dice_roll == false
         d6 = rand(6)
         direction_steps = rand(10..25) # Meander long distances
         dice_roll = true
        end
        message(console,"steps:#{direction_steps},count:#{counter},d6:#{d6}")  # Troubleshooting message for testing
        mode_wander(field, m, p, walkable, items, actors,d6)
        counter += 1
      else
        message(console,"Monster move reset") # Troubleshooting message for testing
        dice_roll = false
        counter = 0
        direction_steps = 0
      end
    end
  end
end
Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.getch
Ncurses.endwin