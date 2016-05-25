require 'ncurses'
include Ncurses 

def generate_random(window)  
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

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window. Invoke with stdscr
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

standard_screen_columns = []                # Standard Screen column aka y
standard_screen_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines)

game_window_lines = 200
game_window_columns = 200
viewport_window_lines = 25
viewport_window_columns = 25

game_window = Ncurses.newwin(game_window_lines, game_window_columns, 0, 0)
viewport_window = Ncurses.derwin(game_window,viewport_window_lines, viewport_window_columns, 0, 0)

generate_random(game_window)
Ncurses.refresh

while Ncurses.getch != 27
	
end

Ncurses.endwin