require_relative 'library'
require 'ncurses'
require 'oj'
require 'json'
include Ncurses                                                                

def save_state(seed,total_bunkers,items,walkable,all_items,all_beacons,all_bunkers,actors)
  all_the_data = {}
  seed_json = {"seed" => seed}
  total_bunkers_json = {"total_bunkers" => total_bunkers}
  items_json = {"items" => items}
  walkable_json = {"walkable" => walkable}
  all_items_json = {"all_items" => all_items}
  all_beacons_json = {"beacons" => all_beacons}
  bunkers_json = {"bunkers" => all_bunkers}
  actors_json = {"actors" => actors}

  all_the_data.merge!(seed_json)
  all_the_data.merge!(total_bunkers_json)
  all_the_data.merge!(items_json)
  all_the_data.merge!(walkable_json)
  all_the_data.merge!(all_items_json)
  all_the_data.merge!(all_beacons_json)
  all_the_data.merge!(bunkers_json)
  all_the_data.merge!(actors_json)


  # Save data to JSON
  File.open('save.json', 'w') do |f|    
    f.puts Oj::dump all_the_data
    f.close
  end
end

def time_increase(timed)  
  if timed[1] < 59 && timed[0] < 24
    timed[1] += 1
  elsif timed[0] == 23 && timed[1] == 59
    timed[0] == 0
    timed[1] == 0
  else
    timed[0] += 1
    timed[1] = 0
  end 
end

def scr_message(message,bars)
  loading = "[" + "=" * bars + " " * (7 - bars) + "]"
  Ncurses.mvwaddstr(stdscr, 3, 3, "#{message}")
  Ncurses.mvwaddstr(stdscr, 4, 4, "#{loading}")
  Ncurses.refresh
  Ncurses.napms(0500)
end

def scr_clear
  Ncurses.mvwaddstr(stdscr, 3, 3, "                           ")
  Ncurses.refresh
end

=begin
inhospitableLog = File.open("inhospitableLog.txt", "w")
inhospitableLog.puts "#{Time.now} - Game Launched"
inhospitableLog.close
=end

#################################################################################
# Initialize                                                                    #
#################################################################################
@new = 0
Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.start_color
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window. Invoke with stdscr
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters
Ncurses.init_pair(1, COLOR_BLACK, COLOR_WHITE)

@game_initialized = 0
main_menu(@game_initialized, stdscr)

Ncurses.mvwaddstr(stdscr, 2, 2, "Initializing Game")
Ncurses.mvwaddstr(stdscr, 3, 3, "Please wait...")
Ncurses.mvwaddstr(stdscr, 4, 4, "[       ]")
Ncurses.refresh

if @new == 1 # Set to 1 when loading variables, located in ui.rb on line 44
  # Load JSON File
  scr_message("Loading Saved Data",1)
  json = File.read('save.json')
  everything = JSON.parse(json)
  scr_clear

  # Instantiate Windows
  # For each window, define lines,cols variables and work with those instead of direct numbers
  # Demo game uses 4 windows: game_window (aka game map), Viewport (aka what the player sees), console_window and side hud_window.
  # Screen and window variables
  scr_message("Prepare Window Variables",2)
  standard_screen_columns = []                # Standard Screen column aka y
  standard_screen_lines = []               # Standard Screen lines aka x
  Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.
  game_window_lines = 200
  game_window_columns = 200
  viewport_window_lines = 25
  viewport_window_columns = 25
  hud_window_lines = viewport_window_lines
  hud_window_columns = 15
  console_window_lines = 3
  console_window_columns = viewport_window_columns + hud_window_columns
  bunker_area_with_space = (viewport_window_lines * viewport_window_columns * 10) + 11 # 11 x 11 is the area of the demo bunker  
  scr_clear

  # Load JSON Data
  scr_message("Loading Game Variables",3)
  total_bunkers = everything["total_bunkers"].to_i
  seed = everything["seed"].to_i
  actors_from_json = everything["actors"]
  actors = []
  items = everything["items"]
  all_items = []
  all_beacons = []
  all_bunkers = everything["bunkers"]
  walkable = everything["walkable"]
  scr_clear

  # Game Loop Variables
  scr_message("Setting Loop Variables",4)
  direction_steps = 0
  counter = 0   
  dice_roll = false
  hunger_count = 0
  direction_steps = rand(10..25) # Meander long distances
  player_visible = 1
  random_number = Random.new(seed)
  scr_clear

  # Create game windows, then generate the world
  scr_message("Creating Game Windows",5)
  game_window = Ncurses.newwin(game_window_lines, game_window_columns, 0, 0)
  viewport_window = Ncurses.derwin(game_window,viewport_window_lines, viewport_window_columns, 0, 0) # Must not exceed size of terminal or else crash
  console_window = Ncurses.newwin(console_window_lines, console_window_columns, viewport_window_lines, 0) 
  hud_window = Ncurses.newwin(hud_window_lines, hud_window_columns, 0, viewport_window_lines) 
  scr_clear

  scr_message("Generating Map",6)
  generate_map(game_window,total_bunkers,all_items,all_beacons,all_bunkers,actors,seed)
  scr_clear

  scr_message("Generating Actors",7)
  player = Character.new(symb: everything["actors"][0]["symb"],symbcode: everything["actors"][0]["symbcode"],color: everything["actors"][0]["color"],xlines: everything["actors"][0]["xlines"],ycols: everything["actors"][0]["ycols"],blocked: everything["actors"][0]["blocked"],hp: everything["actors"][0]["hp"],hunger: everything["actors"][0]["hunger"],inventory: everything["actors"][0]["inventory"],timeday: everything["actors"][0]["timeday"])
  actors << player
  player.draw(game_window)
  everything["actors"].drop(1).each do |k|
    actors << Character.new(symb: k["symb"],symbcode: k["symbcode"],color: k["color"],xlines: k["xlines"],ycols: k["ycols"],blocked: k["blocked"],hp: k["hp"],hunger: k["hunger"],inventory: k["inventory"]) # Instantiate characters from Json
    draw_to_map(game_window,k)    
  end
  
  everything["beacons"].each do |b|
    all_beacons << Beacon.new(symb: b["symb"], xlines: b["xlines"], ycols: b["ycols"], message: b["message"], active: b["active"])    
    draw_to_map(game_window,b)
  end

  everything["all_items"].each do |i|
    if i["taken"] == false
      all_items << Item.new(symb: i["symb"], symbcode: i["symbcode"], xlines: i["xlines"], ycols: i["ycols"], type: i["type"])    
      draw_to_map(game_window,i)
    end
  end
  scr_clear
else
  # Instantiate Windows
  # For each window, define lines,cols variables and work with those instead of direct numbers
  # Demo game uses 4 windows: game_window (aka game map), Viewport (aka what the player sees), console_window and side hud_window.
  # Screen and window variables
  scr_message("Prepare Window Variables",2)
  seed = rand(1..1000000)
  standard_screen_columns = []                # Standard Screen column aka y
  standard_screen_lines = []               # Standard Screen lines aka x
  Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.
  game_window_lines = 200
  game_window_columns = 200
  viewport_window_lines = 25
  viewport_window_columns = 25
  hud_window_lines = viewport_window_lines
  hud_window_columns = 15
  console_window_lines = 3
  console_window_columns = viewport_window_columns + hud_window_columns
  bunker_area_with_space = (viewport_window_lines * viewport_window_columns * 10) + 11 # 11 x 11 is the area of the demo bunker    
  scr_clear
  
  # Define Actors, Items, Terrain, Bunkers and Beacons
  scr_message("Loading Game Variables",3)
  total_bunkers = ((game_window_lines * game_window_columns) / bunker_area_with_space)
  actors = []
  items = [42,102,109,298,358,365]
  all_items = []
  walkable = [32,34,88,126,288,290,344,382]
  all_beacons = []
  all_bunkers = []
  scr_clear

  # Game Loop Variables
  scr_message("Setting Loop Variables",4)
  direction_steps = 0
  counter = 0   
  dice_roll = false
  hunger_count = 0
  #counter = 0 #wander counter for monster
  direction_steps = rand(10..25) # Meander long distances
  player_visible = 1
  random_number = Random.new(seed)
  scr_clear

  # Create game windows, then generate the world
  scr_message("Creating Game Windows",5)
  game_window = Ncurses.newwin(game_window_lines, game_window_columns, 0, 0)
  viewport_window = Ncurses.derwin(game_window,viewport_window_lines, viewport_window_columns, 0, 0) # Must not exceed size of terminal or else crash
  console_window = Ncurses.newwin(console_window_lines, console_window_columns, viewport_window_lines, 0) 
  hud_window = Ncurses.newwin(hud_window_lines, hud_window_columns, 0, viewport_window_lines)  
  scr_clear

  # Create Player Actor
  scr_message("Generate Actors",6)
  game_window_max_lines = []
  game_window_max_columns = []
  Ncurses.getmaxyx(game_window,game_window_max_columns,game_window_max_lines)   # Get Max Y,X of game_window
  player_start_lines = (game_window_max_lines[0] / 4)
  player_start_columns = (game_window_max_columns[0] / 4)
  player = Character.new(symb: '@', symbcode: 320, xlines: player_start_lines, ycols: player_start_columns, hp: 9, color: 2)
  #monster = Character.new(symb: '@', symbcode: 333, xlines: player_start_lines + 1, ycols: player_start_columns + 1, hp: 3)
  actors << player
  #actors << monster
  scr_clear
  
  scr_message("Generating Map",7)
  generate_map(game_window,total_bunkers,all_items,all_beacons,all_bunkers,actors,seed)

  # Place all Actors from array
  spiral(game_window,10,player,walkable) # Find legal starting position for player  
  actors.each { |actor| actor.draw(game_window)}  # Add all actors to the map

  save_state(seed,total_bunkers,items,walkable,all_items,all_beacons,all_bunkers,actors)
  scr_clear
end

menu_active = 0
@game_initialized = 1

# Set up hud_window and console_window
borders(console_window)                            # Add borders to the console_window
Ncurses.wrefresh(console_window)                   # Refresh console_window window with message
hud_on(hud_window,player)
generate_snow(game_window)
center(viewport_window,game_window,player.xlines,player.ycols)        # Center map on player
Ncurses.wrefresh(viewport_window)
if @new == 1
  message(console_window,"Snowfall covers your tracks")
end
#################################################################################
# Game Loop                                                                     #
#################################################################################
while @game_initialized == 1 && player.hp > 0 && player.hunger > 0 && player.inventory["Token"] < total_bunkers  # While Player hit points and hunger are above 0, and tokens are less than total, keep playing
  if menu_active == 1
    main_menu(@game_initialized, game_window)
    menu_active = 0
    Ncurses.mvwaddstr(stdscr, 2, 2, "Returning to game...")
    Ncurses.refresh
    Ncurses.napms(1000)
  end  
  if random_number.rand(1..100) == 1
    generate_snow(game_window) # what % of snow should be covered?
    message(console_window, "It's snowing...")
  end
  time_increase(player.timeday)
  hud_on(hud_window,player)
  borders(console_window) 
  Ncurses.wrefresh(hud_window)
  Ncurses.wrefresh(console_window)
  Ncurses.wrefresh(viewport_window) # Fixed Monster location
  #temp_hash = {"seed" => "#{seed}"}
  #File.open("game.json", "w") do |f|
  #  f.puts temp_hash.to_json
  #end

  #inhospitableLog = File.open("inhospitableLog.txt", "w")
  #actors.each { |a| inhospitableLog.puts "#{a}.to_yaml" }
  #inhospitableLog.close
  
  input = Ncurses.getch
  case input
    when KEY_UP, 119 # Move Up
      check_space(game_window,hud_window,-1,0,player,walkable,items,actors,all_items,all_beacons)
      #message(console_window, "Step: #{Ncurses.mvwinch(game_window, player.xlines - 1, player.ycols + 0)}") 
      center(viewport_window,game_window,player.xlines,player.ycols)
    when KEY_DOWN, 115 # Move Down      
      check_space(game_window,hud_window,1,0,player,walkable,items,actors,all_items,all_beacons)                  
      center(viewport_window,game_window,player.xlines,player.ycols)   
    when KEY_RIGHT, 100 # Move Right 
      check_space(game_window,hud_window,0,1,player,walkable,items,actors,all_items,all_beacons)     
      center(viewport_window,game_window,player.xlines,player.ycols)    
    when KEY_LEFT, 97 # Move Left   
      check_space(game_window,hud_window,0,-1,player,walkable,items,actors,all_items,all_beacons)          
      center(viewport_window,game_window,player.xlines,player.ycols)     
    when 32 # Spacebar, dont move
      center(viewport_window,game_window,player.xlines,player.ycols)
    when 104 # h
      if player_visible == 1
        player_visible = 0
      elsif player_visible == 0
        player_visible = 1
      end    
    when 114 # r      
      the_beacon = get_distance_all_beacons(player,all_beacons)
      if get_distance(player,the_beacon) < 101
        message(console_window,"Radio: #{static(the_beacon, transmission(game_window,the_beacon,player))}")
      else
        message(console_window,"..zz..zZ..Zzz..")
      end
    when 102 # f
      food = player.inventory["Food"]
      if food > 0
        update_inventory(hud_window, 102, player, -1)
        player.hunger += 1
        Ncurses.mvwaddstr(hud_window, 4, 1, "Hunger: #{player.hunger}")
        Ncurses.wrefresh(hud_window)
      else
        message(console_window, "You have no food to eat.")
      end
    when 109 # m
      medkit = player.inventory["Medkit"]
      if medkit > 0
        player.hp += 1
        update_inventory(hud_window, 109, player, -1)        
        Ncurses.mvwaddstr(hud_window, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud_window)
      else
        message(console_window, "You have no medkits.")
      end
    when 27 # ESC - Main Menu 
      menu_active = 1
    when 101 # e - Save Game
      save_state(seed,total_bunkers,items,walkable,all_items,all_beacons,all_bunkers,actors)
      message(console_window, "Game saved!")
    when KEY_F2, 113, 81 # Quit Game with F2, q or Q
      break
    else
      Ncurses.flash           # Flash screen if undefined input selected
      message(console_window,"Move not valid")  # Display ascii decimal number of selected input
      Ncurses.wrefresh(console_window) 
    end

if menu_active == 0
    # Monsters Move
    actors.except(player).each do |rawr|  
      if rawr.hp <= 0
        Ncurses.mvwaddstr(game_window, rawr.xlines, rawr.ycols, "X") # Turn into dead body
        Ncurses.wrefresh(viewport_window)
      else
        distance_from_player = [(player.xlines - rawr.xlines).abs,(player.ycols - rawr.ycols).abs] # Get positive value of distance between monster and player
        if player_visible == 1 and ((distance_from_player[0] < (viewport_window_lines / 5) and distance_from_player[1] < viewport_window_columns / 5)) # if the monster is visible, chase player  
          mode_hunt2(game_window,hud_window, rawr, player, walkable, items, actors, all_items,all_beacons)           
        else # If player is not visible, wander around
          mode_wander2(game_window,hud_window, rawr, player, walkable, items, actors, all_items,all_beacons)       
        end 
      end
    end

    # Starvation
    if hunger_count <= 100
      hunger_count += 1
    else
      player.hunger -= 1
      hunger_count = 0
      message(console_window,"Your stomach growls")
      Ncurses.mvwaddstr(hud_window, 4, 1, "Hunger: #{player.hunger}")
      Ncurses.wrefresh(hud_window)
    end
  end
end
# End Screen
if player.hp == 0 || player.hunger == 0 || player.inventory["Token"] == 2
  # Starved or died
  if player.hp == 0 || player.hunger == 0
    Ncurses.clear
    Ncurses.mvwaddstr(stdscr, standard_screen_columns[0] / 2, standard_screen_lines[0] / 2, "You have died in the cold wastes.")
    Ncurses.mvwaddstr(stdscr, (standard_screen_columns[0] / 2) + 1, standard_screen_lines[0] / 2, "Abiit nemine salutato.")
    Ncurses.mvwaddstr(stdscr, (standard_screen_columns[0] / 2) + 2, standard_screen_lines[0] / 2, "Press any key to quit") 
    Ncurses.wrefresh(stdscr)
    Ncurses.napms(1000)
    input = Ncurses.getch
    Ncurses.endwin
    Ncurses.clear
    exit
  end
  # Collected all the tokens
  if player.inventory["Token"] == total_bunkers # Change this to reflect total tokens
    Ncurses.clear
    Ncurses.mvwaddstr(stdscr, standard_screen_columns[0] / 2, standard_screen_lines[0] / 2, "You collected all the tokens.")
    Ncurses.mvwaddstr(stdscr, (standard_screen_columns[0] / 2) + 1, standard_screen_lines[0] / 2, "You have been rescued!") 
    Ncurses.mvwaddstr(stdscr, (standard_screen_columns[0] / 2) + 2, standard_screen_lines[0] / 2, "Press 'q' to quit") 
    Ncurses.wrefresh(stdscr)
    Ncurses.napms(1000)
    input = Ncurses.getch
    Ncurses.endwin
    Ncurses.clear
    exit
  end
end

Ncurses.clear
Ncurses.mvwaddstr(stdscr, standard_screen_columns[0] / 2, standard_screen_lines[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.napms(1000)
Ncurses.endwin