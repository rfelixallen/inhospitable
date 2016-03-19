require 'ncurses'
include Ncurses

Ncurses.initscr
Ncurses.mvwaddstr(stdscr, 2, 2, "Testing Screen Dump")
Ncurses.refresh
Ncurses.mvwaddstr(stdscr, 3, 3, "Press any key to save the state.")
Ncurses.refresh
Ncurses.getch

#x = Ncurses.scr_dump()
File.open(testfile.txt, 'w') { |file| file.write("I am some text.") 