require_relative 'ui'

def test_terrain
	puts "Terrain Loaded!"
end

# Demo building
def building(window, lines, cols)
  i = 1
  Ncurses.mvwaddstr(window, lines, cols, "|=======|")
  while i < 8
    Ncurses.mvwaddstr(window, lines + i, cols, "|       |")
    i += 1
  end
  Ncurses.mvwaddstr(window, lines + 4, cols, "|   $   |")
  Ncurses.mvwaddstr(window, lines + 8, cols, "|==b d==|")
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