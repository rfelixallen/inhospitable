require_relative 'ui'

class Array
   def except(value)
     self - [value]
   end
 end

class Actor
  attr_accessor :symb, :symbcode, :color, :xlines, :ycols, :blocked #:hp, :hunger, :inventory#, :weather
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.symbcode = options[:symbcode] || 64 # Should be whatever the ascii code for symb is 
    self.color = options[:color] || 1 # White
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.blocked = options[:blocked] || true

    #self.hp = options[:hp] || 3
    #self.hunger = options[:hunger] || 9
    #self.inventory = options[:inventory] || {"Radio" => 1, "Food" => 0, "Medkit" => 0, "Token" => 0}
    #self.weather = options[:weather] || {"Cold" => 1, "Snow" => 2}
  end

  def export
    me = {
          "symb" => self.symb,
          "symbcode" => self.symbcode,
          "color" => self.color,
          "xlines" => self.xlines,
          "ycols" => self.ycols,
          "blocked" => self.blocked
        }
  end

  def draw(window)
    #Ncurses.init_pair(1, self.color, 0)
    #window.attron(Ncurses.COLOR_PAIR(1))
    Ncurses.mvwaddstr(window, self.xlines, self.ycols, "#{self.symb}")
    #window.attroff(Ncurses.COLOR_PAIR(1))
    #Ncurses.wrefresh(window)
  end

  def move(window,lines,cols)
    self.xlines += lines
    self.ycols += cols    
    Ncurses.mvwaddstr(window, self.xlines + -lines, self.ycols + -cols, " ")
    self.draw(window)
  end
end

class Character < Actor
  attr_accessor :hp, :symbcode, :hunger, :inventory
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.symbcode = options[:symbcode] || 64 # Should be whatever the ascii code for symb is 
    self.color = options[:color] || 1 # White
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.blocked = options[:blocked] || true
    self.hp = options[:hp] || 3
    self.hunger = options[:hunger] || 9
    self.inventory = options[:inventory] || {"Radio" => 1, "Food" => 0, "Medkit" => 0, "Token" => 0}
  end

  def scrub_hash(hash)
    #player = Character.new(symb: '@', symbcode: 64, xlines: player_start_lines, ycols: player_start_columns, hp: 9, color: 2)
    # {"\"symb\"=>\"M\", \"symbcode\"=>77, \"color\"=>1, \"xlines\"=>130, \"ycols\"=>105, \"blocked\"=>true, \"hp\"=>3, \"hunger\"=>9, \"inventory\"=>{\"Radio\"=>1, \"Food\"=>0, \"Medkit\"=>0, \"Token\"=>0}"}
    hash[0] = '' # Remove front {
    hash.chop! # Remove back }
    scrub = hash.gsub!(/\"/, "")
    scrub = hash.gsub!(/(=>)/, ": ")
  end

  def scrub_hash2(hash)
    hash.map{|k,v| "#{k}: #{v}"}.join(', ')
  end
  
  def init_from_json(hash)
    hash.each {|k,v| send("#{k}=",v)}
  end

  def export_character
    me = {
          "symb" => self.symb,
          "symbcode" => self.symbcode,
          "color" => self.color,
          "xlines" => self.xlines,
          "ycols" => self.ycols,
          "blocked" => self.blocked,
          "hp" => self.hp,
          "hunger" => self.hunger,
          "inventory" => self.inventory
        }
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

  def export_beacon
    me = {
          "symb" => self.symb,          
          "color" => self.color,
          "xlines" => self.xlines,
          "ycols" => self.ycols,
          "channel" => self.channel,
          "message" => self.message,
          "active" => self.active          
        }
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

def draw_to_map(window,actor)
  Ncurses.mvwaddstr(window, actor["xlines"], actor["ycols"], "#{actor["symb"]}")
end

def check_space(window,hud,xl,yc,character,walkable,items,actors)
    window_max_lines = []
    window_max_cols = []
    Ncurses.getmaxyx(window,window_max_cols,window_max_lines)   # Get Max Y,X of window
    step = Ncurses.mvwinch(window, character.xlines + xl, character.ycols + yc)
    symbcodes = []
    actors.each do |x|
      symbcodes << x.symbcode
    end
    if ((character.xlines + xl) > 0 and (character.ycols + yc) > 0 and (character.xlines + xl) < (window_max_lines[0]) and (character.ycols + yc) < (window_max_cols[0]))
      if walkable.include?(step) 
        character.move(window,xl,yc)
      elsif symbcodes.include?(step)
        check_target(hud,actors,character,xl,yc)       
      elsif items.include?(step)
        if character.symb == "@"
          update_inventory(hud, step, character, 1)          
          character.move(window, xl, yc)
        end
      else 
        nil
      end
    else
      return false
    end
end

def check_target(hud,actors,character,xl,yc)
  #message(hud,"atk: #{character.symb}")
  #Ncurses.getch
  actors.each do |actor|
    if (actor.xlines == character.xlines + xl) and (actor.ycols == character.ycols + yc)
       attack(actor)
       #message(hud,"Attacked #{actor.symb}")
    end               
  end
end

def attack(x)
    x.hp -= 1
end

def update_inventory(hud, item, player, modifier)
  case item 
  when 42 
    player.inventory["Token"] += modifier
  when 102
    player.inventory["Food"] += modifier
  when 109
    player.inventory["Medkit"] += modifier
  else
    nil
  end
end

def update_hud_inventory(hud, player)
    Ncurses.mvwaddstr(hud, 7, 1, " -(F)ood: #{player.inventory["Food"]}")
    Ncurses.mvwaddstr(hud, 8, 1, " -(M)edkit: #{player.inventory["Medkit"]}")
    Ncurses.mvwaddstr(hud, 9, 1, " -Token: #{player.inventory["Token"]}")
    Ncurses.wrefresh(hud)
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
        #puts "Random #{z}"
        #puts "a[z] => z"
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
  d4 = rand(0..3)
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
  elsif d4 == 3
    check_space(window,hud,1,0,character,walkable,items,actors) # Move Down
    Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
    Ncurses.wrefresh(hud)    
  else
    nil
  end  
end

def mode_hunt2(window, hud, character, player, walkable, items, actors) # New Hunt
  flip = rand.round
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