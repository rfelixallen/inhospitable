require_relative 'terrain'

def test_ui
	puts "UI Loaded!"
end

def drawmenu(item)
  c = 0
  menu = ["NEW GAME", "INSTRUCTIONS", "QUIT"]
  Ncurses.clear
  Ncurses.mvaddstr(0,2,"Inhospitable - Main Menu")
  Ncurses.refresh

  while c <= menu.count # set to total menu items, start at 0
    if c == item
      Ncurses.attron(A_REVERSE)
      Ncurses.mvaddstr(3 + (c * 2), 20, menu[c])
      Ncurses.attroff(A_REVERSE)
    end
    c += 1
  end
  Ncurses.mvaddstr(17,2,"Use arrow keys to move, Enter to select:")
  Ncurses.mvaddstr(18,2,"Version 0.5 - RFAllen 2015")
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

def message(window,message)
  Ncurses.wclear(window)
  borders(window)
  Ncurses.mvwaddstr(window, 1, 2, "#{message}")
  Ncurses.wrefresh(window)
end

def hud_on(hud,player)
  borders(hud)                                
  Ncurses.mvwaddstr(hud, 1, 1, "Inhospitable")
  Ncurses.mvwaddstr(hud, 2, 1, "Pos: [#{player.ycols},#{player.xlines}]")
  Ncurses.mvwaddstr(hud, 3, 1, "HP: #{player.hp}")
  Ncurses.mvwaddstr(hud, 4, 1, "Hunger: #{player.hunger}")
  Ncurses.mvwaddstr(hud, 5, 1, "Inventory:")
  Ncurses.mvwaddstr(hud, 6, 1, " -(R)adio")
  Ncurses.mvwaddstr(hud, 7, 1, " -(F)ood: #{player.inventory["Food"]}")
  Ncurses.mvwaddstr(hud, 8, 1, " -(M)edkit: #{player.inventory["Medkit"]}")
  Ncurses.mvwaddstr(hud, 9, 1, " -Tokens: #{player.inventory["Token"]}")  
  Ncurses.wrefresh(hud)
end
