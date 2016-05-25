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
viewport_window = Ncurses.derwin(game_window,standard_screen_lines[0], standard_screen_columns[0], 0, 0)

Ncurses.mvwaddstr(game_window,1,1,"stdscr cols: #{standard_screen_columns[0]}, stdscr lines: #{standard_screen_lines[0]}")
Ncurses.wrefresh(game_window)

while Ncurses.getch != 27
	standard_screen_columns = []                # Standard Screen column aka y
	standard_screen_lines = []               # Standard Screen lines aka x
	Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines)
	Ncurses.mvwaddstr(game_window,1,1,"stdscr cols: #{standard_screen_columns[0]}, stdscr lines: #{standard_screen_lines[0]}")
	Ncurses.wrefresh(game_window)
	Ncurses.getch
	Ncurses.wclear(game_window)
end

generate_random(game_window)
Ncurses.wrefresh(game_window)


standard_screen_columns = []                # Standard Screen column aka y
standard_screen_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,standard_screen_columns,standard_screen_lines)
parent_col = standard_screen_columns[0]
parent_lines = standard_screen_lines[0]
while 1
	new_col = standard_screen_columns[0]
	new_lines = standard_screen_lines[0]
	if (new_col != parent_col || new_lines != parent_lines)
		parent_lines = new_lines
		parent_col = new_col
		Ncurses.wclear(viewport_window)
		Ncurses.wresize(viewport_window,new_lines,new_col)
		Ncurses.wrefresh(viewport_window)
	end
	Ncurses.mvwaddstr(game_window,1,1,"stdscr cols: #{standard_screen_columns[0]}, stdscr lines: #{standard_screen_lines[0]}")
	Ncurses.wrefresh(game_window)
end
=begin
while 1
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		field.clear

		parent_x = new_x
		parent_y = new_y

		field.resize(new_y, new_x)
		borders(field)
		field.setpos(lines / 2, cols  / 2)
		field.addstr("x = #{parent_x}, y = #{parent_y}")
		field.refresh
	end
	field.refresh
end
=end

Ncurses.endwin