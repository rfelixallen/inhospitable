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

Ncurses.mvwaddstr(stdscr, 2, 2, "Testing if this Terminal is capable of using colors.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
erase

if Ncurses.has_colors?
	Ncurses.mvwaddstr(stdscr, 2, 2, "Test passed. Terminal can use colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
	grefresh
	erase
else
	Ncurses.mvwaddstr(stdscr, 2, 2, "Test failed. Terminal cannot use colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to end the test.")
	grefresh
	erase
	Ncurses.endwin
	exit
end

Ncurses.start_color
Ncurses.mvwaddstr(stdscr, 2, 2, "Colors started. You can use #{Ncurses.COLORS} colors and #{Ncurses.COLOR_PAIRS} color pairs.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
erase

# init_pair(pair code, forground, background)
Ncurses.init_pair(1, COLOR_BLACK, COLOR_RED)
Ncurses.init_pair(2, COLOR_YELLOW, COLOR_BLUE)
Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(1))
Ncurses.mvwaddstr(stdscr, 2, 2, "Color pair initiated. Foreground: Black, Background: Red.")
Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(2))
Ncurses.mvwaddstr(stdscr, 3, 2, "Color pair initiated. Foreground: Yellow, Background: Blue.")
Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(2))
Ncurses.mvwaddstr(stdscr, 4, 2, "Press any key to continue.")
grefresh
erase

if Ncurses.can_change_color?
	Ncurses.init_color(240,1000,750,750)
	Ncurses.init_pair(4, 240, COLOR_WHITE)
	Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(4))
	Ncurses.mvwaddstr(stdscr, 2, 2, "Terminal is capable of creating custom RGB colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
	grefresh
	Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(4))
	erase
else
	Ncurses.mvwaddstr(stdscr, 2, 2, "Terminal cannot create custom RGB colors.")
	Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
	grefresh
	erase
end



Ncurses.endwin
exit