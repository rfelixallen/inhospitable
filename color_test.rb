require 'ncurses'
include Ncurses 

def test
	if Ncurses.has_colors? == true
		puts "color!"
	else
		puts "no color :( "
	end
end

def grefresh
Ncurses.refresh
Ncurses.getch
end

def erase
Ncurses.mvwaddstr(stdscr, 2, 2, "                                                                                ")
Ncurses.mvwaddstr(stdscr, 3, 2, "                                                                                ")
Ncurses.mvwaddstr(stdscr, 4, 2, "                                                                                ")
Ncurses.refresh
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
grefresh
erase

#Ncurses.start_color
Ncurses.mvwaddstr(stdscr, 2, 2, "Testing if this Terminal is capable of using colors.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
erase

has_colors = nil

if Ncurses.has_colors?
	has_colors = true
	Ncurses.mvwaddstr(stdscr, 2, 2, "Test passed. Terminal can use colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
	grefresh
	erase
else
	has_colors = false
	Ncurses.mvwaddstr(stdscr, 2, 2, "Test failed. Terminal cannot use colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
	grefresh
	erase
end


Ncurses.endwin