require_relative 'ui'

class Actor
  attr_accessor :symb, :color, :xlines, :ycols, :blocked #:hp, :hunger, :inventory#, :weather
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.color = options[:color] || 1 # White
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.blocked = options[:blocked] || true

    #self.hp = options[:hp] || 3
    #self.hunger = options[:hunger] || 9
    #self.inventory = options[:inventory] || {"Radio" => 1, "Food" => 0, "Medkit" => 0, "Token" => 0}
    #self.weather = options[:weather] || {"Cold" => 1, "Snow" => 2}
  end

  def draw(window)
    Ncurses.init_pair(1, self.color, 0)
    window.attron(Ncurses.COLOR_PAIR(1))
    Ncurses.mvwaddstr(window, self.xlines, self.ycols, "#{self.symb}")
    #window.attroff(Ncurses.COLOR_PAIR(1))
  end

  def move(window,lines,cols)
    self.xlines += lines
    self.ycols += cols    
    Ncurses.mvwaddstr(window, self.xlines + -lines, self.ycols + -cols, " ")
    self.draw(window)
  end
end

class Character < Actor
  attr_accessor :hp, :hunger, :inventory
    def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.color = options[:color] || 1 # White
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.blocked = options[:blocked] || true
    self.hp = options[:hp] || 3
    self.hunger = options[:hunger] || 9
    self.inventory = options[:inventory] || {"Radio" => 1, "Food" => 0, "Medkit" => 0, "Token" => 0}
  end
end

class Beacon < Actor
  #attr_accessor :symb, :channel, :message, :xlines, :ycols, :active
  attr_accessor :channel, :message, :active
  def initialize(options = {})        
    self.symb = options[:symb] || 'A'
    self.color = options[:color] || 2 # Green
    self.xlines = options[:xlines]
    self.ycols = options[:ycols]
    self.channel = options[:channel] || '1'
    self.message = options[:message] || "01234567890123456789"
    self.active = options[:active] || true
  end
end

class Item < Actor
  attr_accessor :symb, :name, :type,
  def initialize(options = {})
    self.symb = options[:symb]
    self.color = options[:color] || 2 # Green
    self.xlines = options[:xlines]
    self.ycols = options[:ycols]
    self.name = options[:name]
    self.type = options[:type] # "Food", "Medkit"
    #self.count = options[:count] || 1
  end
end

class Tile < Actor
  attr_accessor :name, :symb, :code, :color, :blocked
  def initialize(options = {})
    self.name = options[:name]
    self.symb = options[:symb]
    self.code = options[:code]
    self.color = options[:color] || 1
    self.blocked = options[:blocked] || true
  end
end

def check_actors(window, actors, coord)
  actor_coord = []
  actors.each do |x|
    actor_coord << [x.xlines,x.ycols]
  end
  actor_coord.each do |y|
    coord.eql?(y)
end
end

def check_target(actors, characterxlines, characterycols)
  actors.each do |actor|
    if (actor.xlines == characterxlines)  && (actor.ycols == characterycols)
       attack(actor)
    end               
  end
end

def check_space(window,hud,xl,yc,character,walkable,items,actors)
    window_max_lines = []
    window_max_cols = []
    Ncurses.getmaxyx(window,window_max_cols,window_max_lines)   # Get Max Y,X of window
    step = Ncurses.mvwinch(window, character.xlines + xl, character.ycols + yc)
    if ((character.xlines + xl) > 0 and (character.ycols + yc) > 0 and (character.xlines + xl) < (window_max_lines[0] - 1) and (character.ycols + yc) < (window_max_cols[0] - 1))
      if walkable.include?(step) 
        character.move(window,xl,yc)
      elsif actors.include?(step)
        check_target(actors,character.xlines + xl, character.ycols + yc)       
      elsif items.include?(step)
        update_inventory(hud, step, character, 1)          
        character.move(window, xl, yc)
      else 
        nil
      end
    else
      return false
    end
end

=begin
def check_movement(window,xlines,ycols,walkable,items,actors) # Old Check Step method
    window_max_lines = []
    window_max_cols = []
    Ncurses.getmaxyx(window,window_max_cols,window_max_lines)   # Get Max Y,X of window
    step = Ncurses.mvwinch(window, xlines, ycols)
    if (xlines > 0 and ycols > 0 and xlines < (window_max_lines[0] - 1) and ycols < (window_max_cols[0] - 1))
      if walkable.include?(step) 
        return 1
      elsif actors.include?(step)
        return 2       
      elsif items.include?(step)
        return 3
      else 
        return nil
      end
    else
      return false
    end
end
=end

def update_inventory(hud, item, player, modifier)
  case item 
  when 42 
    player.inventory["Token"] += modifier
    Ncurses.mvwaddstr(hud, 9, 1, " -Token: #{player.inventory["Token"]}")
    Ncurses.wrefresh(hud)
  when 102
    player.inventory["Food"] += modifier
    Ncurses.mvwaddstr(hud, 7, 1, " -(F)ood: #{player.inventory["Food"]}")
    Ncurses.wrefresh(hud)
  when 109
    player.inventory["Medkit"] += modifier
    Ncurses.mvwaddstr(hud, 8, 1, " -(M)edkit: #{player.inventory["Medkit"]}")
    Ncurses.wrefresh(hud)
  else
    nil
  end
end

def attack(x)
    x.hp -= 1
end

def static(beacon, clarity) 
  # Clarity must be between 1 and x
  array = []
  a = beacon.message.split("")
  x = a.count
  i = 0
  case clarity
  when "clear"
    return a.join
  when "low"
    c = x
  when "medium"
    c = 3
  when "high"
    c = 2
  when "far"
    c = 1
  else
    c = nil
  end

  if c == nil
    return nil
  else
    j = x / c # represents what % of message distorted 
    while i < j   
      z = rand(0..x)  
      case z
      when array.include?(z)
        nil
      else
        array << z
        puts "Random #{z}"
        puts "a[z] => z"
        if z % 2 == 0
          a[z] = "z"
        else
          a[z] = ".."
        end
        i += 1
      end
    end  
    return a.join
  end
end

def get_distance(player, beacon)  
  distance_from_player = (player.xlines - beacon.xlines).abs + (player.ycols - beacon.ycols).abs
  return distance_from_player
end

def get_distance_all_beacons(player, all_beacons)
  # Make hash of beacons and their distances, then return beacon with shortest distance  
  distances = Hash[all_beacons.collect { |v| [v,get_distance(player,v)] }]
  y = distances.values.min_by { |x| x }
  return distances.key(y)
end

def transmission(window,beacon,player)
  distance_from_player = (player.xlines - beacon.xlines).abs + (player.ycols - beacon.ycols).abs
  case distance_from_player
  when 0..24
    return "clear"
  when 25..49
    return "low"
  when 50..74
    return "medium"
  when 75..100
    return "high"
  else
    return "far"
  end
end

# Modes
def mode_wander2(window, hud, character, player, walkable, items, actors) # New Wander Method
  d4 = rand(4)
  if d4 == 0
    check_space(window,hud,0,-1,character,walkable,items,actors) # Move Left
    Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
    Ncurses.wrefresh(hud)    
  elsif d4 == 1    
    check_space(window,hud,0,1,character,walkable,items,actors) # Move Right
    Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
    Ncurses.wrefresh(hud)    
  elsif d4 == 2
    check_space(window,hud,-1,0,character,walkable,items,actors) # Move Up
    Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
    Ncurses.wrefresh(hud)    
  elsif d4 == 4
    check_space(window,hud,1,0,character,walkable,items,actors) # Move Down
    Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
    Ncurses.wrefresh(hud)    
  else
    nil
  end  
end

def mode_hunt2(window, hud, character, player, walkable, items, actors) # New Hunt
  flip = rand(2)
  if flip == 0    
    if character.ycols > player.ycols 
      check_space(window,hud,0,-1,character,walkable,items,actors) # Move Left
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    elsif character.ycols < player.ycols
      check_space(window,hud,0,1,character,walkable,items,actors) # Move Right
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    elsif character.xlines > player.xlines 
      check_space(window,hud,-1,0,character,walkable,items,actors) # Move Up
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else character.xlines < player.xlines
      check_space(window,hud,1,0,character,walkable,items,actors) # Move Down
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    end
  else
    if character.xlines < player.xlines
      check_space(window,hud,1,0,character,walkable,items,actors) # Move Down
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    elsif character.xlines > player.xlines 
      check_space(window,hud,-1,0,character,walkable,items,actors) # Move Up
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    elsif character.ycols < player.ycols
      check_space(window,hud,0,1,character,walkable,items,actors) # Move Right
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else character.ycols > player.ycols 
      check_space(window,hud,0,-1,character,walkable,items,actors) # Move Left
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)    
    end
  end
end
=begin
def mode_wander(window, hud, character, player, walkable, items, actors, d6) # OLD METHOD
  # Move Left
  if d6 == 0
    check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors) # Left
    if check1 == 1
      #move_character_y(window,character,-1)
      character.move(window,0,-1)
    elsif check1 == 2
      check_target(actors, character)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end

  # Move Right        
  elsif d6 == 1
    check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors) # Right
    if check2 == 1
      #move_character_y(window,character,1)
      character.move(window,0,1)
    elsif check2 == 2
      check_target(actors, character)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end                  

  # Move Up
  elsif d6 == 2
    check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors) # Up
    if check3 == 1
      #move_character_x(window,character,-1)
      character.move(window,-1,0)
    elsif check3 == 2
      check_target(actors, character)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end                           

  # Move Down
  elsif d6 == 3
    check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors) # Down
    if check4 == 1
      #move_character_x(window,character,1)
      character.move(window,-1,0)
    elsif check4 == 2
      check_target(actors, character)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end        
  else
    nil        
  end   
end
=end

# This mode causes the character to hunt the player.
=begin
def mode_hunt(window, hud, character, player, walkable, items, actors) # Old Hunt
  flip = rand(2)
  if flip == 0        
    check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors) # Left
    check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors) # Right
    check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors) # Up
    check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors) # Down
        
    # Move Left
    if character.ycols > player.ycols  
      if check1 == 1
        #move_character_y(window,character,-1)
        character.move(window,0,-1)
      elsif check1 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
      else
        nil
      end              

    # Move Right        
    elsif character.ycols < player.ycols
      if check2 == 1
        #move_character_y(window,character,1)
        character.move(window,0,1)
      elsif check2 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end              
      
    # Move Up
    elsif character.xlines > player.xlines 
      if check3 == 1
        #move_character_x(window,character,-1)
        character.move(window,-1,0)
      elsif check3 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end                    
    
    # Move Down
    else character.xlines < player.xlines
      if check4 == 1
        #move_character_x(window,character,1)
        character.move(window,1,0)
      elsif check4 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end          
    end
  else
    check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors)
    check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors)
    check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors)
    check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors)                      
      
    # Move Up
    if character.xlines > player.xlines 
      if check3 == 1
        #move_character_x(window,character,-1)
        character.move(window,-1,0)
      elsif check3 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end                    
    
    # Move Down
    elsif character.xlines < player.xlines
      if check4 == 1
        #move_character_x(window,character,1)
        character.move(window,1,0)
      elsif check4 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end

    # Move Left
    elsif character.ycols > player.ycols  
      if check1 == 1
        #move_character_y(window,character,-1)
        character.move(window,0,-1)
      elsif check1 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end              

    # Move Right        
    else character.ycols < player.ycols
      if check2 == 1
        #move_character_y(window,character,1)
        character.move(window,0,1)
      elsif check2 == 2
        check_target(actors, character)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end          
    end
  end
end
=end