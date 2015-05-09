require_relative 'ui'

class Character
  attr_accessor :symb, :xlines, :ycols, :hp, :hunger, :inventory, :weather
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.hp = options[:hp] || 3
    self.hunger = options[:hunger] || 9
    self.inventory = options[:inventory] || ["Radio"]
    self.weather = options[:weather] || {"Cold" => 1, "Snow" => 2}
  end
end

class Beacon
  attr_accessor :symb, :channel, :message, :xlines, :ycols, :active
  def initialize(options = {})    
    self.symb = options[:symb] || 'A'
    self.channel = options[:channel] || '1'
    self.message = options[:message] || "..0123456789"
    self.xlines = options[:xlines]
    self.ycols = options[:ycols]
    self.active = options[:active] || true
  end
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
=begin
  all_active_beacons = []
  all_beacons.each do |x|
    if x.active == true
      all_active_beacons << x
    end
=end
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

def test_actors
  puts "Actors Loaded!"
end

def check_movement(window,xlines,ycols,walkable,items,actors)
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
        return false
      end
    else
      return false
    end
end

def move_character_x(window,character,i)
    character.xlines += i
    Ncurses.mvwaddstr(window, character.xlines + -i, character.ycols, " ")
    Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
end

def move_character_y(window,character,i)
    character.ycols += i
    Ncurses.mvwaddstr(window, character.xlines, character.ycols + -i, " ")
    Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
end

def attack(x)
    x.hp -= 1
end

# Modes
def mode_wander(window, hud, character, player, walkable, items, actors, d6)
  # Move Left
  if d6 == 0
    check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors) # Left
    if check1 == 1
      move_character_y(window,character,-1)
    elsif check1 == 2
      attack(player)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end

  # Move Right        
  elsif d6 == 1
    check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors) # Right
    if check2 == 1
      move_character_y(window,character,1)
    elsif check2 == 2
      attack(player)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end                  

  # Move Up
  elsif d6 == 2
    check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors) # Up
    if check3 == 1
      move_character_x(window,character,-1)
    elsif check3 == 2
      attack(player)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end                           

  # Move Down
  elsif d6 == 3
    check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors) # Down
    if check4 == 1
      move_character_x(window,character,1)
    elsif check4 == 2
      attack(player)
      Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
    else
      nil
    end        
  else
    nil        
  end   
end

# This mode causes the character to hunt the player.
def mode_hunt(window, hud, character, player, walkable, items, actors)
  flip = rand(2)
  if flip == 0        
    check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors) # Left
    check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors) # Right
    check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors) # Up
    check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors) # Down
        
    # Move Left
    if character.ycols > player.ycols  
      if check1 == 1
        move_character_y(window,character,-1)
      elsif check1 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
      Ncurses.wrefresh(hud)
      else
        nil
      end              

    # Move Right        
    elsif character.ycols < player.ycols
      if check2 == 1
        move_character_y(window,character,1)
      elsif check2 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end              
      
    # Move Up
    elsif character.xlines > player.xlines 
      if check3 == 1
        move_character_x(window,character,-1)
      elsif check3 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end                    
    
    # Move Down
    else character.xlines < player.xlines
      if check4 == 1
        move_character_x(window,character,1)
      elsif check4 == 2
        attack(player)
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
        move_character_x(window,character,-1)
      elsif check3 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end                    
    
    # Move Down
    elsif character.xlines < player.xlines
      if check4 == 1
        move_character_x(window,character,1)
      elsif check4 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end

    # Move Left
    elsif character.ycols > player.ycols  
      if check1 == 1
        move_character_y(window,character,-1)
      elsif check1 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end              

    # Move Right        
    else character.ycols < player.ycols
      if check2 == 1
        move_character_y(window,character,1)
      elsif check2 == 2
        attack(player)
        Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
        Ncurses.wrefresh(hud)
      else
        nil
      end          
    end
  end
end