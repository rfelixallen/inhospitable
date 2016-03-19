require 'ncurses'
include Ncurses

Ncurses.initscr
Ncurses.stdscr
Ncurses.cbreak
Ncurses.noecho
Ncurses.refresh

Ncurses.addstr("Testing Screen Dump")
Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.refresh

window = Ncurses.newwin(15, 15, 0, 0)

i = 0
j = 0
for i in 0..15
	for j in 0..15
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
Ncurses.wrefresh(window)
Ncurses.getch
#x = Ncurses.scr_dump("textfile.txt")
x = File.open("save1.dat", "w")
#s.write(Ncurses.putwin(stdscr,"save1.sav"))
#s.close()
s = Ncurses.putwin(window,x)

if s == ERR
	Ncurses.addstr("Error writing to file.\n")
else
	Ncurses.addstr("Window saved to disk.\n")
end
Ncurses.refresh


#File.open("testfile.txt", 'w') { |file| file.write("I am some text.") }
Ncurses.endwin
