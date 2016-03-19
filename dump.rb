require 'ncurses'
include Ncurses

Ncurses.initscr
Ncurses.cbreak
Ncurses.noecho
Ncurses.refresh

Ncurses.addstr("Testing Screen Dump")
Ncurses.refresh
Ncurses.getch

x = Ncurses.scr_dump("textfile.txt")
#File.open("testfile.txt", 'w') { |file| file.write("I am some text.") }
Ncurses.endwin
