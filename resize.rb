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
game_window_lines = 1000
game_window_columns = 1000
viewport_window_lines = standard_screen_lines[0]
viewport_window_columns = standard_screen_columns[0]
game_window = Ncurses.newwin(game_window_lines, game_window_columns, 0, 0)
#viewport_window = Ncurses.derwin(game_window,viewport_window_lines, viewport_window_columns, 0, 0)

Ncurses.mvwaddstr(game_window,1,1,"stdscr cols: #{standard_screen_columns[0]}, stdscr lines: #{standard_screen_lines[0]}")
Ncurses.wrefresh(game_window)

while Ncurses.getch != 27
	standard_screen_columns = []                # Standard Screen column aka y
	standard_screen_lines = []               # Standard Screen lines aka x
	Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines)
	Ncurses.mvwaddstr(game_window,1,1,"stdscr cols: #{standard_screen_columns[0]}, stdscr lines: #{standard_screen_lines[0]}")
	Ncurses.wrefresh(game_window)
	Ncurses.getch
end

generate_random(game_window)
Ncurses.wrefresh(game_window)
while Ncurses.getch != 27
	Ncurses.wrefresh(game_window)
end

Ncurses.endwin