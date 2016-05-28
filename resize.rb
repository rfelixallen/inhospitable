require 'ncurses'
include Ncurses 

def generate_random(window)  
  # Draws random characters to each tile
  i = 1
  j = 1
  for i in 1..(Ncurses.COLS - 1)
    for j in 1..(Ncurses.LINES - 1)
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

def borders(window)
  # Draws borders around the window
  i = 1

  # Draw Borders
  # Draw side borders
  while i <= (Ncurses.LINES - 1) do
    Ncurses.mvwaddstr(window, i, 0, "|")
    Ncurses.mvwaddstr(window, i, Ncurses.COLS - 1, "|")
    i += 1
  end
  # Draw Top/bottom borders
  j = 0
  while j <= (Ncurses.COLS - 1) do
    Ncurses.mvwaddstr(window, 0, j, "+")
    Ncurses.mvwaddstr(window, Ncurses.LINES - 1, j, "+")
    j += 1
  end
end

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window. Invoke with stdscr
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

game_window = Ncurses.newwin(200, 200, 0, 0)
viewport_window = Ncurses.derwin(game_window, Ncurses.LINES, Ncurses.COLS, 0, 0)
generate_random(game_window)
Ncurses.wrefresh(game_window)
borders(viewport_window)
Ncurses.wrefresh(viewport_window)
Ncurses.getch

Ncurses.mvwaddstr(viewport_window, Ncurses.LINES / 2, Ncurses.COLS / 2,"Cols = #{Ncurses.COLS}, Lines = #{Ncurses.LINES}")
Ncurses.wrefresh(viewport_window)

while ((key = Ncurses.getch) != 27) 
	if key == Ncurses::KEY_RESIZE
		Ncurses.wclear(viewport_window)
		borders(viewport_window)
		Ncurses.mvwaddstr(viewport_window, Ncurses.LINES / 2, Ncurses.COLS / 2,"Cols: #{Ncurses.COLS}, Lines: #{Ncurses.LINES}")
		Ncurses.wrefresh(viewport_window)
	end	
	Ncurses.wrefresh(game_window)
end
Ncurses.endwin