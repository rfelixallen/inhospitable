require 'ncurses'
include Ncurses 


    Ncurses.initscr
    Ncurses.mvprintw(0, 0, "COLS = #{Ncurses.COLS}, LINES = #{Ncurses.LINES}")
    for i in 0..Ncurses.COLS
        Ncurses.mvaddstr(1, i, '*')
        i += 1
    end
    Ncurses.refresh

    key = nil
    while ((key = Ncurses.getch) != 27) 
        if (key == Ncurses::KEY_RESIZE) 
            Ncurses.clear
            Ncurses.mvprintw(0, 0, "COLS = #{Ncurses.COLS}, LINES = #{Ncurses.LINES}")
            for i in 0..Ncurses.COLS
                Ncurses.mvaddstr(1, i, '*')
                i += 1
            end
            Ncurses.refresh
        end
    end

    Ncurses.endwin