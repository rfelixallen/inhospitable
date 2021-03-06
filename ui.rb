require_relative 'library'

def drawmenu(item,menu)
  c = 0  
  m = menu.length
  Ncurses.clear
  Ncurses.mvaddstr(0,2,"Inhospitable - Main Menu")
  Ncurses.refresh 
  m.times do |i|
    Ncurses.mvaddstr(3 + (i * 2), 20, menu[i])
  end
  while c <= m # set to total menu items, start at 0
    if c == item
      Ncurses.attron(A_REVERSE)
      Ncurses.mvaddstr(3 + (c * 2), 20, menu[c])
      Ncurses.attroff(A_REVERSE)
    end
    c += 1
  end
  Ncurses.mvaddstr(17,2,"Use arrow keys to move - Enter to select")
  Ncurses.mvaddstr(18,2,"Version 0.5 - RFAllen 2015")
end

def main_menu(state,screen)
  # Main Menu
  menuitem = 0
  #menu = ["PLAY GAME", "INSTRUCTIONS", "SAVE GAME", "CONTINUE", "QUIT"]
  
  if @game_initialized == 0
    menu = ["CONTINUE", "NEW GAME", "INSTRUCTIONS", "QUIT"]
  else 
    menu = ["CONTINUE", "INSTRUCTIONS", "QUIT"]
  end
  drawmenu(menuitem,menu)
  key = 0
  m = menu.length - 1
  if @game_initialized == 0
    while key != 113
      drawmenu(menuitem,menu)
      key = Ncurses.getch
      case key
      when KEY_DOWN
        menuitem += 1
        if (menuitem > m) then menuitem = 0 end
      when KEY_UP
        menuitem -= 1
        if (menuitem < 0) then menuitem = m end
      when KEY_ENTER,012,013,015 # Had a problem with calling enter. One of these did it.
        if menuitem == 0 && File.exist?("save.json") # First Spot: CONTINUE GAME
          @new = 1
          key = 113
        elsif menuitem == 1 # Second Spot: New Game
          @new == 0
          key = 113
        elsif menuitem == 2 # Third Spot: Instructions
          menu_instructions 
        elsif menuitem == 3 # Fourth Spot: Quit Game
          Ncurses.clear
          Ncurses.mvwaddstr(stdscr, 1, 1, "Good Bye!")
          Ncurses.wrefresh(stdscr)
          Ncurses.napms(1000)
          Ncurses.endwin
          exit
        else
          Ncurses.flash
        end
      else
        Ncurses.flash
      end
    end
  else
    while key != 113
      drawmenu(menuitem,menu)
      key = Ncurses.getch
      case key
      when KEY_DOWN
        menuitem += 1
        if (menuitem > m) then menuitem = 0 end
      when KEY_UP
        menuitem -= 1
        if (menuitem < 0) then menuitem = m end
      when KEY_ENTER,012,013,015 # Had a problem with calling enter. One of these did it.
        if menuitem == 0  # First Spot: CONTINUE GAME
          key = 113
        elsif menuitem == 1 # Second Spot: Instructions
          menu_instructions 
        elsif menuitem == 2 # Third Spot: Quit Game
          Ncurses.clear
          Ncurses.mvwaddstr(stdscr, 1, 1, "Good Bye!")
          Ncurses.wrefresh(stdscr)
          Ncurses.napms(1000)
          Ncurses.endwin
          exit
        else
          Ncurses.flash
        end
      else
        Ncurses.flash
      end
    end
  end
  Ncurses.clear
end

def menu_instructions
      Ncurses.clear
      Ncurses.mvaddstr(0,2,"Inhospitable - Instructions")
      Ncurses.mvaddstr(2,2,"Arrow Keys / WASD - Up, Down, Left, Right")
      Ncurses.mvaddstr(3,2,"(r) - Use Radio")
      Ncurses.mvaddstr(4,2,"(f) - Eat Food - Icon: f")
      Ncurses.mvaddstr(5,2,"(m) - Use Medkit - Icon: m")
      Ncurses.mvaddstr(6,2,"(e) - Save Game")
      Ncurses.mvaddstr(7,2,"(q) - Quit Game")
      Ncurses.mvaddstr(8,2,"(Spacebar) - Skip Movement")
      Ncurses.mvaddstr(9,2,"Use Radio to find Bunkers with supplies!")
      Ncurses.mvaddstr(10,2,"Walk into Monsters to attack - icon (M)")
      Ncurses.mvaddstr(11,2,"Walk into Radio Towers to deactivate - icon (A)")
      Ncurses.mvaddstr(12,2,"Collect all Tokens to finish game")

      Ncurses.mvaddstr(13,2,"Press any key to return to menu")
      Ncurses.refresh
      Ncurses.getch
end

def borders(window)
  # Draws borders around the window
  i = 1
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  # Draw Borders
  # Draw side borders
  while i <= (w_y[0] - 1) do
    Ncurses.mvwaddstr(window, i, 0, "|")
    Ncurses.mvwaddstr(window, i, w_x[0] - 1, "|")
    i += 1
  end
  # Draw Top/bottom borders
  j = 0
  while j <= (w_x[0] - 1) do
    Ncurses.mvwaddstr(window, 0, j, "+")
    Ncurses.mvwaddstr(window, w_y[0] - 1, j, "+")
    j += 1
  end
end

def borders2(window)
  # Draws borders around the window
  i = 1
  w_y = []
  w_x = []
  Ncurses.getmaxyx(window,w_y,w_x)
  
  # Draw side borders
  while i <= (w_y[0] - 1) do
    Ncurses.mvwaddstr(window, i, 0, "|")
    Ncurses.mvwaddstr(window, i, w_x[0] - 1, "|")
    i += 1
  end
  # Draw Top/bottom borders
  j = 0
  while j <= (w_x[0] - 1) do
    Ncurses.mvwaddstr(window, 0, j, "+")
    Ncurses.mvwaddstr(window, w_y[0] - 1, j, "+")
    j += 1
  end
end

def center(subwin,parent,p_rows,p_cols)
  rr = []   # Frame y Positions
  cc = []   # Frame x Positions
  Ncurses.getbegyx(subwin, rr, cc)

  hh = []   # Parent Window Height
  ww = []   # Parent Window Width
  Ncurses.getmaxyx(parent, hh, ww)

  height = [] # Frame Window Height
  width = []  # Frame Window Width
  Ncurses.getmaxyx(subwin, width, height)

  r = p_rows - (height[0] / 2)
  c = p_cols - (width[0] / 2) 

  if (c + width[0]) >= ww[0]
    delta = ww[0] - (c + width[0])
    cc[0] = c + delta
  else
    cc[0] = c
  end

  if (r + height[0]) >= hh[0]
    delta = hh[0] - (r + height[0])
    rr[0] = r + delta
  else
    rr[0] = r
  end

  if r < 0
    rr[0] = 0
  end

  if c < 0
    cc[0] = 0
  end

  Ncurses.mvderwin(subwin,rr[0],cc[0])
  Ncurses.wrefresh(subwin)
end

def resize_window(window)

end

def message(window,message)
  Ncurses.wclear(window)
  borders(window)
  Ncurses.mvwaddstr(window, 1, 2, "#{message}")
  Ncurses.wrefresh(window)
end

def convert_time(x)
  if x.to_s.length == 1
    return "0" + x.to_s
  else
    return x.to_s
  end
end

def hud_on(hud,player)
  Ncurses.wclear(hud)
  borders(hud)                                
  Ncurses.mvwaddstr(hud, 1, 1, "Inhospitable")
  #Ncurses.mvwaddstr(hud, 2, 1, "Pos: [#{player.ycols},#{player.xlines}]") # Remove this in final game. 
  Ncurses.mvwaddstr(hud, 3, 1, "Time: #{convert_time(player.timeday[0])}:#{convert_time(player.timeday[1])}")
  Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
  Ncurses.mvwaddstr(hud, 5, 1, "Hunger: #{player.hunger}")
  Ncurses.mvwaddstr(hud, 6, 1, "Inventory:")
  Ncurses.mvwaddstr(hud, 7, 1, " -(R)adio")
  Ncurses.mvwaddstr(hud, 8, 1, " -(F)ood: #{player.inventory["Food"]}")
  Ncurses.mvwaddstr(hud, 9, 1, " -(M)ed: #{player.inventory["Medkit"]}")
  Ncurses.mvwaddstr(hud, 10, 1, " -Tokens: #{player.inventory["Token"]}")  
  Ncurses.wrefresh(hud)
end

def log_w(somefile,message)
somefile = File.open("#{somefile}.txt", "w")
somefile.puts "#{message}"
somefile.close
end

def log_a(somefile,message)
somefile = File.open("inhospitableLog.txt", "a")
somefile.puts "#{message}"
somefile.close
end