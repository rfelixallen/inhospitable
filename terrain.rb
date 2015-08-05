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

def test_terrain
	puts "Terrain Loaded!"
end

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

def demo_bunker(window, lines, cols)
  bunker = ["|==========|",
            "|   |  *|  |",
            "|   |   |  |",
            "|= === === |",
            "|          |",
            "|          |",
            "|          |",
            "|          |",
            "|          |",
            "|== =======|"]
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

def make_bunker(window,all_beacons,all_bunkers,actors)
  success = 0
  w_y = []
  w_x = []
  i = 0
  j = 0
  Ncurses.getmaxyx(window,w_y,w_x)
  while success != 1
    bunker_x = rand(2..(w_x[0] - 11)) # subtract total height of predefined structure
    bunker_y = rand(2..(w_y[0] - 11)) # subtract total width of predefined structure
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
      for i in (bunker_x)..(bunker_x + 11)
        for j in (bunker_y)..(bunker_y + 11)
          coordinates = [i,j]
          all_bunkers << coordinates
        end
      end
      success = 1
      demo_bunker(window,bunker_x,bunker_y)   # Adds a building to map. It overlays anything underneath it         
      make_beacon(window,all_beacons,bunker_x,bunker_y)
      flip = rand.round
        if flip == 1
          make_monster(bunker_x + 1, bunker_y + 1,actors)
        end
    end
  end
end

def make_beacon(window,all_beacons,bunker_x,bunker_y)
  variable_name = Random.new(cantor_pairing(bunker_x,bunker_y))
  message = "Broadcast #{cantor_pairing(bunker_x,bunker_y)}"
  variable_name = Beacon.new(xlines: bunker_x + 1, ycols: bunker_y + 6, message: message)
  Ncurses.mvwaddstr(window, variable_name.xlines, variable_name.ycols, variable_name.symb)
  all_beacons << variable_name
end

def make_monster(monster_x,monster_y,actors)
      monster = cantor_pairing(monster_x,monster_y)
      monster = Character.new(symb: 'M', symbcode: 77, xlines: monster_x, ycols: monster_y, hp: 3)
      actors << monster
end

def draw_map(window)
  borders(window)
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
  borders(window)
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

def generate_perlin(window)
  borders(window)
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  1.step(w_x[0], 0.01) do |x|
    1.step(w_y[0], 0.01) do |y|      
      n2d = Perlin::Noise.new 2, :interval => 200
      contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC, 3)
      n = n2d[x, y]
      n = contrast.call n
      if n < 0.35
        Ncurses.mvwaddstr(window, x, y, "^")
      elsif n > 0.35 and n < 0.60 
        Ncurses.mvwaddstr(window, x, y, "~")
      else
        Ncurses.mvwaddstr(window, x, y, "#")
      end
    #puts n
    Ncurses.wrefresh(window)
    end
  end
end