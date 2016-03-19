require 'ncurses'
include Ncurses

Ncurses.initscr
Ncurses.cbreak
Ncurses.noecho
Ncurses.refresh

Ncurses.addstr("You are about to restore a screen.")
Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.refresh

x = Ncurses.scr_restore("save.sav")
Ncurses.refresh
Ncurses.getch

Ncurses.endwin