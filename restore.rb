require 'ncurses'
include Ncurses

# Files must be restored from .dat files

Ncurses.initscr
Ncurses.cbreak
Ncurses.noecho
Ncurses.refresh

Ncurses.addstr("You are about to restore a screen.")
Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.refresh

# Scr_restore example
#x = Ncurses.scr_restore("save.sav")

# getwin example
x = File.open("save1.sav", "r")
win = Ncurses.getwin(x)
x.close

Ncurses.wrefresh(win)
Ncurses.getch
Ncurses.clear

Ncurses.endwin