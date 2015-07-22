require_relative 'library'
require 'ncurses'
include Ncurses                                                                
#################################################################################
# Initialize                                                                    #
#################################################################################

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
#Ncurses.start_color
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

=begin
# Initialize Color Pairs
# Assumes everything has black background.
colors = Ncurses.COLORS
color_i = 0
colors.times do |fg|
  Ncurses.init_pair(color_i, fg, 0)
  color_i += 1
end
=end

# Main Menu
menuitem = 0
drawmenu(menuitem)
key = 0
while key != 113
  drawmenu(menuitem)
  key = Ncurses.getch
  case key
  when KEY_DOWN
    menuitem += 1
    if (menuitem > 1) 
      menuitem = 0
      #break
    end
  when KEY_UP
    menuitem -= 1
    if (menuitem < 0) 
      menuitem = 1
      #break
    end
  when KEY_ENTER,012,013,015 # Had a problem with calling enter. One of these did it.
    if menuitem == 0 # Play Game
      key = 113
    elsif menuitem == 1 # Quit Game
      Ncurses.clear
      Ncurses.endwin
      exit
    else
      Ncurses.flash
    end
  else
    Ncurses.flash
  end
end
Ncurses.clear

# Instantiate Windows
# For each window, define lines,cols variables and work with those instead of direct numbers
# Demo game uses 4 windows: Field (aka game map), Viewport (aka what the player sees), Console and side HUD.
sd_cols = []                # Standard Screen column aka y
sd_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,sd_cols,sd_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.
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

# Welcome Screen
Ncurses.mvwaddstr(stdscr, 2, 2, "Welcome to Inhospitable!")
Ncurses.mvwaddstr(stdscr, 3, 3, "Terminal window must be at least these dimensions:")
Ncurses.mvwaddstr(stdscr, 4, 3, "Rows = #{view_lines}, Columns = #{view_cols}")
Ncurses.mvwaddstr(stdscr, 5, 3, "Your Terminal: Rows = #{sd_lines[0]}, Columns = #{sd_cols[0]}")
Ncurses.refresh             # Refresh window to display new text
Ncurses.getch               # Wait for user input
Ncurses.clear               # Clear the screen once player is ready to proceed
Ncurses.refresh             # Refresh window to display cleared screen

objects = []

# Draw map
#draw_map(field)         # Draws a simple map with one terrain type
snow = Tile.new(name: "Snow", symb: "~", code: 1, color: "WHITE", blocked: true)
wall_horizontal = Tile.new(name: "Wall_Horizontal", code: 2, symb: "=", color: "YELLOW", blocked: true)
wall_vertical = Tile.new(name: "Wall_Vertical", code: 3, symb: "|", color: "Yellow", blocked: true)
all_tile = []
all_tile.concat([snow, wall_horizontal, wall_vertical])

# Experiments with tiles as objects
#objects << snow
#draw_map_tiles(field, snow)
draw_map_tiles(field, all_tile[0])

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
#actors = []         # Array will contain ascii decimal value of actor symbols 
actors = [64,77,320,333] # Array with hard coded character numbers
items = [42,102,109]        # Array contains ascii decimal value of all items on ground
walkable = [32,88,126, 288] # ' ', '~', 'X' #somehow 288 became space

# Setup Actors
field_max_lines = []
field_max_cols = []
Ncurses.getmaxyx(field,field_max_cols,field_max_lines)   # Get Max Y,X of Field
player_start_lines = (field_max_lines[0] / 4)
player_start_cols = (field_max_cols[0] / 4)

# Create Player Actor
p = Character.new(symb: '@', symbcode: 320, xlines: player_start_lines, ycols: player_start_cols, hp: 9) # Begin player in top, right corner
#p = Character.new(xlines: player_start_lines, ycols: player_start_cols, hp: 9) # Begin player in top, right corner
actors << p
#actor_index.push(p.id)                                     # Add player symbol to array of actor symbols
#Ncurses.mvwaddstr(field, p.xlines, p.ycols, "#{p.symb}")        # Draw layer to map


# Create Monster
m = Character.new(symb: 'M', symbcode: 333, xlines: player_start_cols + view_cols, ycols: player_start_lines + view_lines, hp: 3) # Begin Monster near player, but out of sight
#m = Character.new('M', xlines: player_start_cols + view_cols, ycols: player_start_lines + view_lines, hp: 3) # Begin Monster near player, but out of sight
actors << m
#actors.each { |actor| actor.draw(field)}  # Add all actors to the map
p.draw(field)
m.draw(field)

# Set up Console
borders(console)                            # Add borders to the console
Ncurses.wrefresh(console)                   # Refresh console window with message

# Set up HUD (Heads-Up-Display)
hud_on(hud,p,m)
center(viewp,field,p.xlines,p.ycols)                            # Center map on player
Ncurses.wrefresh(viewp)
#################################################################################
# Game Loop                                                                     #
#################################################################################
# Game Variables - Initial set and forget
direction_steps = 0
counter = 0   
dice_roll = false
hunger_count = 0
counter = 0 #wander counter for monster
direction_steps = rand(10..25) # Meander long distances
#message(console, "Actors: #{actors[0].}")
# Begin Loop
while p.hp > 0 && p.hunger > 0 && p.inventory["Token"] < 2  # While Player hit points and hunger are above 0, and tokens are less than total, keep playing
  Ncurses.mvwaddstr(hud, 2, 1, "Pos: [#{p.ycols},#{p.xlines}]")
  Ncurses.mvwaddstr(hud, 10, 1, "M Pos: [#{m.ycols},#{m.xlines}]") # Troubleshooting
  Ncurses.wrefresh(hud)
  input = Ncurses.getch
  case input
    when KEY_UP, 119 # Move Up
      step = Ncurses.mvwinch(field, p.xlines - 1, p.ycols) # Troubleshooting
      message(console,"Step: #{step}")  # Troubleshooting
      check_space(field,hud,-1,0,p,walkable,items,actors) 
      center(viewp,field,p.xlines,p.ycols)
      Ncurses.mvwaddstr(hud, 11, 1, "M HP: #{m.hp}") # Troubleshooting
      Ncurses.wrefresh(hud)       # Troubleshooting
    when KEY_DOWN, 115 # Move Down      
      step = Ncurses.mvwinch(field, p.xlines + 1, p.ycols) # Troubleshooting
      message(console,"Step: #{step}")  # Troubleshooting
      check_space(field,hud,1,0,p,walkable,items,actors)                  
      center(viewp,field,p.xlines,p.ycols)   
      Ncurses.mvwaddstr(hud, 11, 1, "M HP: #{m.hp}") # Troubleshooting
      Ncurses.wrefresh(hud)       # Troubleshooting  
    when KEY_RIGHT, 100 # Move Right 
      step = Ncurses.mvwinch(field, p.xlines, p.ycols + 1) # Troubleshooting
      message(console,"Step: #{step}")  # Troubleshooting
      check_space(field,hud,0,1,p,walkable,items,actors)     
      center(viewp,field,p.xlines,p.ycols)  
      Ncurses.mvwaddstr(hud, 11, 1, "M HP: #{m.hp}") # Troubleshooting
      Ncurses.wrefresh(hud)       # Troubleshooting    
    when KEY_LEFT, 97 # Move Left   
      step = Ncurses.mvwinch(field, p.xlines, p.ycols - 1) # Troubleshooting
      message(console,"Step: #{step}")  # Troubleshooting
      check_space(field,hud,0,-1,p,walkable,items,actors)          
      center(viewp,field,p.xlines,p.ycols) 
      Ncurses.mvwaddstr(hud, 11, 1, "M HP: #{m.hp}") # Troubleshooting
      Ncurses.wrefresh(hud)       # Troubleshooting     
    when 32 # Spacebar, dont move
      center(viewp,field,p.xlines,p.ycols)
      Ncurses.mvwaddstr(hud, 11, 1, "M HP: #{m.hp}") # Troubleshooting
      Ncurses.wrefresh(hud)       # Troubleshooting
    when 101 # e # Troubleshooting
      attack(m)
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
      mode_hunt2(field,hud, m, p, walkable, items, actors)      
    else # If player is not visible, wander around
      if counter < direction_steps
        if dice_roll == false         
         direction_steps = rand(10..25) # Meander long distances
         dice_roll = true
        end
        #message(console,"steps:#{direction_steps},count:#{counter}")  # Troubleshooting message for testing        
        mode_wander2(field,hud, m, p, walkable, items, actors)        
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
  if hunger_count <= 100
    hunger_count += 1
  else
    p.hunger -= 1
    hunger_count = 0
    message(console,"Your stomach growls")
    Ncurses.mvwaddstr(hud, 4, 1, "Hunger: #{p.hunger}")
    Ncurses.wrefresh(hud)
  end
end

# End Screen


# Starved or died
if p.hp == 0 || p.hunger == 0 || p.inventory["Token"] == 2
  if p.hp == 0 || p.hunger == 0
    Ncurses.clear
    Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "You have died in the cold wastes.")
    Ncurses.mvwaddstr(stdscr, (sd_cols[0] / 2) + 1, sd_lines[0] / 2, "Abiit nemine salutato.")
    Ncurses.mvwaddstr(stdscr, (sd_cols[0] / 2) + 2, sd_lines[0] / 2, "Press 'q' to quit") 
    Ncurses.wrefresh(stdscr)
    input = Ncurses.getch
    case input
        when KEY_F2, 113, 81 # Quit Game with F2, q or Q
          #break
    end
  end
  if p.inventory["Token"] == 2
    Ncurses.clear
    Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "You collected all the tokens.")
    Ncurses.mvwaddstr(stdscr, (sd_cols[0] / 2) + 1, sd_lines[0] / 2, "You have been rescued!") 
    Ncurses.mvwaddstr(stdscr, (sd_cols[0] / 2) + 2, sd_lines[0] / 2, "Press 'q' to quit") 
    Ncurses.wrefresh(stdscr)
    input = Ncurses.getch
    case input
        when KEY_F2, 113, 81 # Quit Game with F2, q or Q
    #break
    end
  end
end

# Collected all the tokens


Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.napms(1000)
Ncurses.endwin