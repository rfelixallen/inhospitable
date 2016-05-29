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

def convert_nc_to_rgb(array)
	r = array[0]
	g = array[1]
	b = array[2]
	r = r * 0.255
	g = g * 0.255
	b = b * 0.255
	array[0] = r.round
	array[1] = g.round
	array[2] = b.round
end

def convert_rgb_to_nc(array)
	r = array[0]
	g = array[1]
	b = array[2]
	r = r * 3.921568
	g = g * 3.921568
	b = b * 3.921568
	array[0] = r.round
	array[1] = g.round
	array[2] = b.round
end

def message(c,x,y,message)
	Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(c))
	Ncurses.mvwaddstr(stdscr, x, y, "#{message}")
	Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(c))
end

def message_bold(c,x,y,message)
	Ncurses.wattron(stdscr,A_BOLD)
	Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(c))
	Ncurses.mvwaddstr(stdscr, x, y, "#{message}")
	Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(c))
	Ncurses.wattroff(stdscr,A_BOLD)
end

def message_bold_blink(c,x,y,message)
	Ncurses.wattron(stdscr,A_BOLD | A_BLINK)
	Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(c))
	Ncurses.mvwaddstr(stdscr, x, y, "#{message}")
	Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(c))
	Ncurses.wattroff(stdscr,A_BOLD | A_BLINK)
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
	Ncurses.init_color(6,1000,500,0) # This didnt work for some reason
	Ncurses.init_pair(4, 6, COLOR_BLACK)
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

Ncurses.mvwaddstr(stdscr, 2, 2, "Testing color pairs - normal.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
Ncurses.clear

Ncurses.init_pair(0, 0, COLOR_BLACK)
Ncurses.init_pair(1, 1, COLOR_BLACK)
Ncurses.init_pair(2, 2, COLOR_BLACK)
Ncurses.init_pair(3, 3, COLOR_BLACK)
Ncurses.init_pair(4, 4, COLOR_BLACK)
Ncurses.init_pair(5, 5, COLOR_BLACK)
Ncurses.init_pair(6, 6, COLOR_BLACK)
Ncurses.init_pair(7, 7, COLOR_BLACK)
Ncurses.init_pair(8, 8, COLOR_BLACK)
Ncurses.init_pair(9, 9, COLOR_BLACK)
Ncurses.init_pair(10, 10, COLOR_BLACK)
Ncurses.init_pair(11, 11, COLOR_BLACK)
Ncurses.init_pair(12, 12, COLOR_BLACK)
Ncurses.init_pair(13, 13, COLOR_BLACK)
Ncurses.init_pair(14, 14, COLOR_BLACK)
Ncurses.init_pair(15, 15, COLOR_BLACK)
Ncurses.init_pair(16, 16, COLOR_BLACK)
Ncurses.init_pair(17, 17, COLOR_BLACK)
Ncurses.init_pair(18, 18, COLOR_BLACK)
Ncurses.init_pair(19, 19, COLOR_BLACK)
Ncurses.init_pair(20, 20, COLOR_BLACK)
Ncurses.init_pair(21, 21, COLOR_BLACK)
Ncurses.init_pair(22, 22, COLOR_BLACK)
Ncurses.init_pair(23, 23, COLOR_BLACK)
Ncurses.init_pair(24, 24, COLOR_BLACK)
Ncurses.init_pair(25, 25, COLOR_BLACK)
Ncurses.init_pair(26, 26, COLOR_BLACK)
Ncurses.init_pair(27, 27, COLOR_BLACK)
Ncurses.init_pair(28, 28, COLOR_BLACK)
Ncurses.init_pair(29, 29, COLOR_BLACK)
Ncurses.init_pair(30, 30, COLOR_BLACK)
Ncurses.init_pair(31, COLOR_WHITE, 10)


c = 0
x = 0
y = 1
30.times do
	message(c,x,y,"Color Pair: #{c}")	
	x += 1
	c += 1
end
grefresh
Ncurses.clear

Ncurses.mvwaddstr(stdscr, 2, 2, "Testing color pairs - bold.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
Ncurses.clear

c = 0
x = 0
y = 1
30.times do
	message_bold(c,x,y,"Color Pair: #{c}")	
	x += 1
	c += 1
end
grefresh
Ncurses.clear

Ncurses.mvwaddstr(stdscr, 2, 2, "Testing color pairs - bold & blink.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
Ncurses.clear

c = 0
x = 0
y = 1
30.times do
	message_bold_blink(c,x,y,"Color Pair: #{c}")	
	x += 1
	c += 1
end
grefresh
Ncurses.clear

Ncurses.mvwaddstr(stdscr, 2, 2, "Background color test.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
Ncurses.clear

Ncurses.bkgd(Ncurses.COLOR_PAIR(31))
Ncurses.wattron(stdscr,Ncurses.COLOR_PAIR(31))
Ncurses.mvwaddstr(stdscr, 2, 2, "Background color")
Ncurses.wattroff(stdscr,Ncurses.COLOR_PAIR(31))
Ncurses.refresh
Ncurses.getch

Ncurses.bkgd(Ncurses.COLOR_PAIR(0))
Ncurses.mvwaddstr(stdscr, 2, 2, "Test Screen Flash")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press Escape to exit the flash test.")
Ncurses.mvwaddstr(stdscr, 4, 2, "Press any key to continue.")
grefresh
Ncurses.clear

while Ncurses.getch != 27
	Ncurses.flash
end

Ncurses.mvwaddstr(stdscr, 2, 2, "Color Test Complete.")
Ncurses.mvwaddstr(stdscr, 3, 2, "Press any key to continue.")
grefresh
Ncurses.clear


Ncurses.endwin
exit