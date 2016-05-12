require_relative 'ui'
require_relative 'actors'
require 'perlin_noise'

#index of tile types with character, colorcode
=begin
h = {:a => "val1", :b => "val2", :c => "val3"}
keys = h.keys

h[keys[0]] # "val1"
h[keys[2]] # "val3"

tiletype = [
  ('~', 7), # Snow, white
  ('|', 3), # Wall, Yellow
]
=end

# Demo building
def building(window, lines, cols)
  i = 1
  Ncurses.mvwaddstr(window, lines, cols, "|==========|")
  while i < 8
    Ncurses.mvwaddstr(window, lines + i, cols, "|          |")
    i += 1
  end
  Ncurses.mvwaddstr(window, lines + 8, cols, "|== =======|")
end

def build(window, lines, cols, structure_array)
  i = 0
  structure_array.each do |x|
  Ncurses.mvwaddstr(window, lines + i, cols, x)  
  i += 1
  end
end            

def demo_bunker(window, lines, cols, seed)
  chance = Random.new(seed)
  bunker = ["              ",
            " |==========| ",
            " |   |   |  | ",
            " |   |   |  | ",
            " |= === === | ",            
            " |          | ",
            " |          | ",
            " |          | ",
            " |== =======| ",
            "              "]
  build(window, lines, cols, bunker)
=begin  
  med_count = chance.rand(0..1)
  food_count = chance.rand(2..5)
  i = 5
  while i < 8
    j = 2
    d = chance.rand(1..3)
    while j < 8
      if d == 1 and med_count > 0
        Ncurses.mvwaddstr(window, lines + i, cols + j, "m")
        med_count -= 1
      elsif d == 2 and food_count > 0
        Ncurses.mvwaddstr(window, lines + i, cols + j, "f")
        food_count -= 1
      else
        Ncurses.mvwaddstr(window, lines + i, cols + j, " ")
      end
      j += 1
    end
    i += 1
  end
=end  
end

def demo_bunker2(window, lines, cols, all_tiles)
  pallette = all_tiles
  bunker = ["322222222223",
            "3   3   3  3",
            "3   3   3  3",
            "32 222 222 3",
            "3          3",
            "3          3",
            "3          3",
            "3          3",
            "3          3",
            "322 22222223"]
  t = 0
  r = bunker.count
  while t < r
    q = bunker[i].scan(/./).uniq!
    t += 1
  end
=begin
  tiles = bunker1.scan(/./).uniq!
  pallette.each do |x|
    bunker = bunker.gsub()
  bunker = bunker.gsub("3", "#{pallette[2].symb}")
=end
  build(window, lines, cols, bunker)
  med_count = rand(0..1)
  food_count = rand(2..5)
  i = 5
  while i < 9
    j = 1
    d = rand(1..3)
    while j < 11
      if d == 1 and med_count > 0
        Ncurses.mvwaddstr(window, lines + i, cols + j, "m")
        med_count -= 1
      elsif d == 2 and food_count > 0
        Ncurses.mvwaddstr(window, lines + i, cols + j, "f")
        food_count -= 1
      else
        Ncurses.mvwaddstr(window, lines + i, cols + j, " ")
      end
      j += 1
    end
    i += 1
  end
end

# Create unique number from two other numbers
def cantor_pairing(n, m)
    (n + m) * (n + m + 1) / 2 + m
end

def make_bunker(window,all_items,all_beacons,all_bunkers,actors,seed)
  success = 0
  chance = Random.new(seed)
  w_y = []
  w_x = []
  i = 0
  j = 0
  Ncurses.getmaxyx(window,w_y,w_x)
  if @new == 1
    all_bunkers.each do |x|
      demo_bunker(window,x[0],x[1],seed)
      #make_beacon(window,all_beacons,x[0],x[1],seed)
    end
  else
    while success != 1
      bunker_x = chance.rand(2..(w_x[0] - 11)) # subtract total height of predefined structure
      bunker_y = chance.rand(2..(w_y[0] - 11)) # subtract total width of predefined structure
      test_bunker_coordinates = []
      for i in (bunker_x)..(bunker_x + 11)
        for j in (bunker_y)..(bunker_y + 11)
          coordinates = [i,j]
          test_bunker_coordinates << coordinates
        end
      end
      if (test_bunker_coordinates & all_bunkers).any?
        success = 0 # Restart Loop
      else
=begin        
        construction = []
        for i in (bunker_x)..(bunker_x + 11)
          for j in (bunker_y)..(bunker_y + 11)            
            coordinates = [i,j]
            #construction << coordinates
            all_bunkers << coordinates
          end
        end
=end                
        success = 1
        #all_bunkers << construction
        all_bunkers << [bunker_x,bunker_y]
        demo_bunker(window,bunker_x,bunker_y,seed)   # Adds a building to map. It overlays anything underneath it         
        make_beacon(window,all_beacons,bunker_x,bunker_y,seed)
        make_item(window,all_items,bunker_x + 2,bunker_y + 8,seed,"Token")
        flip = chance.rand.round
          if flip == 1
            make_monster(bunker_x + 2, bunker_y + 2,actors)
          end
        flip = chance.rand(0..2)
        if flip == 0
          make_item(window,all_items,bunker_x + 2,bunker_y + 10,seed,"Food")
        elsif flip == 1
          make_item(window,all_items,bunker_x + 2,bunker_y + 10,seed,"Food")
          make_item(window,all_items,bunker_x + 2,bunker_y + 11,seed,"Food")
        else
        end
        flip = chance.rand(0..2)
        if flip == 0
          make_item(window,all_items,bunker_x + 3,bunker_y + 10,seed,"Medkit")
        elsif flip == 1
          make_item(window,all_items,bunker_x + 3,bunker_y + 10,seed,"Medkit")
          make_item(window,all_items,bunker_x + 3,bunker_y + 11,seed,"Medkit")
        else
        end             
      end
    end
  end
end

def make_beacon(window,all_beacons,bunker_x,bunker_y,seed)
  chance = Random.new(seed)
  variable_name = chance.rand(cantor_pairing(bunker_x,bunker_y))
  message = "Broadcast #{cantor_pairing(bunker_x,bunker_y)}"
  variable_name = Beacon.new(xlines: bunker_x + 2, ycols: bunker_y + 6, message: message)
  Ncurses.mvwaddstr(window, variable_name.xlines, variable_name.ycols, variable_name.symb)
  all_beacons << variable_name
  #all_beacons.merge!(variable_name.export_beacon)
end

def make_monster(monster_x,monster_y,actors)
      monster = cantor_pairing(monster_x,monster_y)
      monster = Character.new(symb: 'M', symbcode: 77, xlines: monster_x, ycols: monster_y, hp: 3)
      actors << monster
      #actors.merge!(monster.export_character)
end

def make_item(window,all_items,bunker_x,bunker_y,seed,type)
  case type
      when "Food"
        thing = Item.new(symb: 'f', symbcode: 102, xlines: bunker_x, ycols: bunker_y, type: type)
      when "Medkit"
        thing = Item.new(symb: 'm', symbcode: 109, xlines: bunker_x, ycols: bunker_y, type: type)
      when "Token"
        thing = Item.new(symb: '*', symbcode: 42, xlines: bunker_x, ycols: bunker_y, type: type)
      end
  Ncurses.mvwaddstr(window, thing.xlines, thing.ycols, thing.symb)
  all_items << thing
end

def draw_map(window)
  #borders(window)
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  
  i = 1
  j = 1
  for i in 1..(w_x[0] - 1)
    for j in 1..(w_y[0] - 1)
      Ncurses.init_pair(1, COLOR_BLACK, COLOR_WHITE)
      Ncurses.wattron(window,Ncurses.COLOR_PAIR(1))
      Ncurses.mvwaddstr(window, i, j, "~")
      Ncurses.wattroff(window,Ncurses.COLOR_PAIR(1))
    end
  end
end

def draw_map_tiles(window, tile)
  borders2(window)
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  
  i = 1
  j = 1
  for i in 1..(w_x[0] - 1)
    for j in 1..(w_y[0] - 1)
      Ncurses.mvwaddstr(window, i, j, "#{tile.symb}")
    end
  end
end

def generate_random(window)
  borders(window)
  # Draws random characters to each tile
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  
  i = 1
  j = 1
  for i in 1..(w_x[0] - 1)
    for j in 1..(w_y[0] - 1)
      dice = rand(4)
      case dice 
      when 0
        Ncurses.mvwaddstr(window, i, j, "#")
      when 1
        Ncurses.mvwaddstr(window, i, j, "*")
      when 2
        Ncurses.mvwaddstr(window, i, j, "^")
      else
        Ncurses.mvwaddstr(window, i, j, "~")
      end
    end
  end
end

#right now this rights about 100 characters in one position before advancing to the next
def generate_perlin(window,seed)
  borders(window)
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_x,w_y)
  random_seed = seed
  n3d = Perlin::Noise.new 3, :interval => 100, :seed => random_seed
  contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC, 3)
  #Ncurses.init_pair(1, COLOR_BLACK, COLOR_WHITE)
  Ncurses.wattron(window,Ncurses.COLOR_PAIR(1))
  1.step(w_x[0] - 2, 1.0) do |x| # x == whole integer, which will always give .5
    1.step(w_y[0] - 2, 1.0) do |y|
      
    i = (x / w_x[0]) * 10 # (0.01..1.00) * 10 == (.1..9.9)
    j = (y / w_y[0]) * 10 # (0.01..1.00) * 10 == (.1..9.9)

      n = n3d[i,j,0.8]
      #n = contrast.call n
      if n > 0.4 and n < 0.7
        Ncurses.mvwaddstr(window, x, y, "~")
      else
        Ncurses.mvwaddstr(window, x, y, "#")
      end
    end
  end
  Ncurses.wattroff(window,Ncurses.COLOR_PAIR(1))
end

def generate_snow(window)  
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_x,w_y)
  
  x = 1
  y = 1
  for x in 1..(w_x[0] - 1)
    for y in 1..(w_y[0] - 1)
      terrain = Ncurses.mvwinch(window, x, y)
      if terrain == 34 || terrain == 32
        flip = rand.round
        if flip == 0
          Ncurses.wattron(window,Ncurses.COLOR_PAIR(1))
          Ncurses.mvwaddstr(window, x, y, "~")   
          Ncurses.wattroff(window,Ncurses.COLOR_PAIR(1))
        end  
      end
    end
  end
end


def generate_map(window,total_bunkers,all_items,all_beacons,all_bunkers,actors,seed)
  generate_perlin(window,seed)
  bunker_start = 0
  while bunker_start <= total_bunkers
    make_bunker(window,all_items,all_beacons,all_bunkers,actors,seed)
    bunker_start += 1
  end
end

def spiral(window,n,character,walkable) # n is the max dimensions. ex n = 5, this is a 5x5 square.
  #a = [character.xlines,character.ycols]
  x = 1 # X is how many steps to go
  halt = false
  window_max_lines = []
  window_max_cols = []
  Ncurses.getmaxyx(window,window_max_cols,window_max_lines)   # Get Max Y,X of window
  step = Ncurses.mvwinch(window, character.xlines, character.ycols)
  #Ncurses.mvwaddstr(window, 40, 40, "#{step}")
  
  while step != 382
    #break if halt
    if ((character.xlines) > 0 and (character.ycols) > 0 and (character.xlines) < (window_max_lines[0] - 1) and (character.ycols) < (window_max_cols[0] - 1))
      for i in 1..n
        if i % 2 != 0
          x.times do
            character.ycols += 1
            step = Ncurses.mvwinch(window, character.xlines, character.ycols)
              if walkable.include?(step)
                #halt = true 
                #character.move(window,character.xlines,character.ycols)
                #break if halt
                break
              end
          end

          x.times do
            character.xlines += 1
            step = Ncurses.mvwinch(window, character.xlines, character.ycols)
              if walkable.include?(step)
                #halt = true 
                #character.move(window,character.xlines,character.ycols)
                #break if halt
                break
              end
          end
          x += 1
          #i += 1
        else  
          x.times do
            character.ycols -= 1
            step = Ncurses.mvwinch(window, character.xlines, character.ycols)
              if walkable.include?(step) 
                #character.move(window,character.xlines,character.ycols)
                #halt = true
                #break if halt
                break
              end
          end

          step = Ncurses.mvwinch(window, character.xlines, character.ycols)
          if walkable.include?(step) 
            break
          end
          x.times do
            character.xlines -= 1
            step = Ncurses.mvwinch(window, character.xlines, character.ycols)
              if walkable.include?(step) 
                #character.move(window,character.xlines,character.ycols)
                #halt = true
                #break if halt
                break
              end
          end
          x += 1
          #i += 1
        end
      end
    end
  end
end