require 'ncurses'
include Ncurses 

def test
	if Ncurses.has_colors? == true
		puts "color!"
	else
		puts "no color :( "
	end
end

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window. Invoke with stdscr
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

Ncurses.mvwaddstr(stdscr, 2, 2, "This program will test colors in terminal.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Colors are not yet active.")
Ncurses.mvwaddstr(stdscr, 4, 2, "Press any key to continue.")
Ncurses.refresh
Ncurses.getch
Ncurses.endwin