require_relative 'ui'

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
            "|   |   |  |",
            "|   |   |  |",
            "|= === === |",
            "|          |",
            "|          |",
            "|          |",
            "|          |",
            "|          |",
            "|== =======|"]
  build(window, lines, cols, bunker)
  med_count = rand(1..2)
  food_count = rand(1..2)
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