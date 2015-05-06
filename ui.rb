require_relative 'terrain'

def test_ui
	puts "UI Loaded!"
end

def borders(window)
  # Draws borders and fills all game map tiles with snow.
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