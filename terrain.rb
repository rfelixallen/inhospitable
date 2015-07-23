require_relative 'ui'
require_relative 'actors'

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

def cantor_pairing(n, m)
    (n + m) * (n + m + 1) / 2 + m
end

def make_beacon(all_beacons,bunker_x,bunker_y)
  b1 = Beacon.new(xlines: bunker_x + 1, ycols: bunker_y + 6)
  all_beacons << b1
  variable_name = Random.new(cantor_pairing(bunker_x,bunker_y))
  instance_variable_set("@#{variable_name}", :something)
end

def make_bunker(window)
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  bunker_x = rand(2..(w_x[0] - 11)) # subtract total height of predefined structure
  bunker_y = rand(2..(w_y[0] - 11)) # subtract total width of predefined structure
  demo_bunker(window,bunker_x,bunker_y)   # Adds a building to map. It overlays anything underneath it         
end

def draw_map(window)
  borders(window)

  # Draw Terrain
  # Draw snow on every tile
  i = 1
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  while i < w_x[0] - 1
    j = 1
    while j < w_y[0] - 1    
      Ncurses.mvwaddstr(window, i, j, "~")
      j += 1
    end
    i += 1
  end
end

def draw_map_tiles(window, tile)
  borders(window)

  # Draw Terrain
  # Draw snow on every tile
  i = 1
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  while i < w_x[0] - 1
    j = 1
    while j < w_y[0] - 1    
      Ncurses.mvwaddstr(window, i, j, tile.symb)
      j += 1
    end
    i += 1
  end
end

def generate_random(window)
  borders(window)
  # Draws random characters to each tile
  i = 1
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  while i < w_x[0] - 1
    j = 1
    while j < w_y[0] - 1
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
    j += 1
    end
    i += 1
  end
end