require_relative 'library'
require 'ncurses'
include Ncurses                                                                
#################################################################################
# Initialize                                                                    #
#################################################################################

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

# Instantiate Windows
# For each window, define lines,cols variables and work with those instead of direct numbers
# Demo game uses 4 windows: Field (aka game map), Viewport (aka what the player sees), Console and side HUD.
field_lines = 200
field_cols = 200
view_lines = 25
view_cols = 25
hud_lines = view_lines
hud_cols = 15
console_lines = 3
console_cols = view_cols + hud_cols

field = Ncurses.newwin(field_lines, field_cols, 0, 0)
viewp = Ncurses.derwin(field,view_lines, view_cols, 0, 0) # Must not exceed size of terminal or else crash
console = Ncurses.newwin(console_lines, console_cols, view_lines, 0) 
hud = Ncurses.newwin(hud_lines, hud_cols, 0, view_lines) 

sd_cols = []                # Standard Screen column aka y
sd_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,sd_cols,sd_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.

# Welcome Screen
Ncurses.mvwaddstr(stdscr, 2, 2, "Welcome to Inhospitable!")
Ncurses.mvwaddstr(stdscr, 3, 3, "Terminal window must be at least these dimensions:")
Ncurses.mvwaddstr(stdscr, 4, 3, "Rows = #{view_lines}, Columns = #{view_cols}")
Ncurses.mvwaddstr(stdscr, 5, 3, "Your Terminal: Rows = #{sd_lines[0]}, Columns = #{sd_cols[0]}")
Ncurses.refresh             # Refresh window to display new text
Ncurses.getch               # Wait for user input
Ncurses.clear               # Clear the screen once player is ready to proceed
Ncurses.refresh             # Refresh window to display cleared screen

# Draw map
draw_map(field)         # Draws a simple map with one terrain type

# Draw bunkers and beacons
all_beacons = []
bunker_x = rand(2..(field_lines - 11))
bunker_y = rand(2..(field_cols - 11))
demo_bunker(field,bunker_x,bunker_y)   # Adds a building to map. It overlays anything underneath it         
b1 = Beacon.new(xlines: bunker_x + 1, ycols: bunker_y + 6)
all_beacons << b1
Ncurses.mvwaddstr(field, b1.xlines, b1.ycols, b1.symb)

bunker_x = rand(2..(field_lines - 11))
bunker_y = rand(2..(field_cols - 11))
demo_bunker(field,bunker_x,bunker_y)   # Adds a building to map. It overlays anything underneath it         
b2 = Beacon.new(xlines: bunker_x + 1, ycols: bunker_y + 6, message: "HELPHELPHELP")
all_beacons << b2
Ncurses.mvwaddstr(field, b2.xlines, b2.ycols, b2.symb)

=begin
# Define item types
food = Item.new("f", "Beans", "Food")
medkit = Item.new("m", "First Aid Kit", "Medkit")
=end

# Define Actors, Items and Terrain
actors = []         # Array will contain ascii decimal value of actor symbols 
items = [42,102,109]        # Array contains ascii decimal value of all items on ground
walkable = [32,88,126] # ' ', '~', 'X'
actor_index = []

# Setup Actors
field_max_lines = []
field_max_cols = []
Ncurses.getmaxyx(field,field_max_cols,field_max_lines)   # Get Max Y,X of Field
player_start_lines = (field_max_lines[0] / 4)
player_start_cols = (field_max_cols[0] / 4)

# Create Player Character
p = Character.new(symb: '@', xlines: player_start_lines, ycols: player_start_cols, hp: 9) # Begin player in top, right corner
p.id = p.object_id
actors << p.symb.ord
actor_index.push(p.id)                                     # Add player symbol to array of actor symbols
Ncurses.mvwaddstr(field, p.xlines, p.ycols, "#{p.symb}")        # Draw layer to map
center(viewp,field,p.xlines,p.ycols)                            # Center map on player

# Create Monster
m = Character.new(symb: 'M', xlines: player_start_cols + view_cols, ycols: player_start_lines + view_lines, hp: 3) # Begin Monster near player, but out of sight
m.id = m.object_id
actors << m.symb.ord                                                # Add player symbol to array of actor symbols
actor_index.push(m.id)
Ncurses.mvwaddstr(field, m.xlines, m.ycols, "#{m.symb}")                # Draw Monster to map
Ncurses.wrefresh(viewp) # Update viewport with all previous changes

actor_locations = {}
actor_locations = {m => [m.xlines,m.ycols]}

# Set up Console
borders(console)                            # Add borders to the console
Ncurses.wrefresh(console)                   # Refresh console window with message

# Set up HUD (Heads-Up-Display)
hud_on(hud,p)
#################################################################################
# Game Loop                                                                     #
#################################################################################
# Game Variables - Initial set and forget
direction_steps = 0
counter = 0   
dice_roll = false
hunger_count = 0

# Begin Loop
while p.hp > 0 && p.hunger > 0 && p.inventory["Token"] < 2  # While Player hit points and hunger are above 0, and tokens are less than total, keep playing
  input = Ncurses.getch
  case input
    when KEY_UP, 119 # Move Up
      check = check_movement(field,p.xlines - 1,p.ycols,walkable,items,actors)
        if check == 1      
          move_character_x(field,p,-1)
        elsif check == 2
          #return object ID
          attack(m)
        elsif check == 3
          step = Ncurses.mvwinch(field, p.xlines - 1, p.ycols)
          update_inventory(hud, step, p, 1)
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
          step = Ncurses.mvwinch(field, p.xlines + 1, p.ycols)
          update_inventory(hud, step, p, 1)
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
          step = Ncurses.mvwinch(field, p.xlines, p.ycols + 1)
          update_inventory(hud, step, p, 1)
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
          step = Ncurses.mvwinch(field, p.xlines, p.ycols - 1)
          update_inventory(hud, step, p, 1)
          move_character_y(field,p,-1)          
        else # No valid move
          nil
        end      
      center(viewp,field,p.xlines,p.ycols)      
    when 114 # r      
      the_beacon = get_distance_all_beacons(p,all_beacons)
      if get_distance(p,the_beacon) < 101
        message(console,"Radio: #{static(the_beacon, transmission(field,the_beacon,p))}")
      else
        message(console,"..zz..zZ..Zzz..")
      end
    when 102
      food = p.inventory["Food"]
      if food > 0
        update_inventory(hud, 102, p, -1)
        p.hunger += 1
        Ncurses.mvwaddstr(hud, 4, 1, "Hunger: #{p.hunger}")
        Ncurses.wrefresh(hud)
      else
        message(console, "You have no food to eat.")
      end
    when 109
      medkit = p.inventory["Medkit"]
      if medkit > 0
        p.hp += 1
        update_inventory(hud, 109, p, -1)        
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{p.hp}")
        Ncurses.wrefresh(hud)
      else
        message(console, "You have no medkits.")
      end
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
      #message(console,"MONSTER HUNTS YOU!")  # Troubleshooting message for testing
      mode_hunt(field,hud, m, p, walkable, items, actors)
    else # If player is not visible, wander around
      if counter <= direction_steps
        if dice_roll == false
         d6 = rand(6)
         direction_steps = rand(10..25) # Meander long distances
         dice_roll = true
        end
        #message(console,"steps:#{direction_steps},count:#{counter},d6:#{d6}")  # Troubleshooting message for testing
        mode_wander(field,hud, m, p, walkable, items, actors,d6)
        counter += 1
      else
        #message(console,"Monster move reset") # Troubleshooting message for testing
        dice_roll = false
        counter = 0
        direction_steps = 0
      end
    end
  end

  # Starvation
  if hunger_count <= 50
    hunger_count += 1
  else
    p.hunger -= 1
    hunger_count = 0
    message(console,"Your stomach growls")
    Ncurses.mvwaddstr(hud, 4, 1, "Hunger: #{p.hunger}")
    Ncurses.wrefresh(hud)
  end
end

# Starved or died
if p.hp == 0 || p.hunger == 0
  Ncurses.clear
  Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "You have died.")
  Ncurses.wrefresh(stdscr)
  Ncurses.getch
end

# Collected all the tokens
if p.inventory["Token"] == 2
  Ncurses.clear
  Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "You collected all the tokens.")
  Ncurses.mvwaddstr(stdscr, (sd_cols[0] / 2) + 1, sd_lines[0] / 2, "You have been rescued!")  
  Ncurses.wrefresh(stdscr)
  Ncurses.napms(4000)
end

Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.napms(1000)
Ncurses.endwin