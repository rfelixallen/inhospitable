require_relative 'library'

class Videogame
	attr_accessor :stateActive, :seedValue, :walkableTiles, :itemTiles
	def initialize(options = {})
    	self.stateActive = options[:stateActive] || false
    	self.seedValue = options[:seedValue] || rand(1..10000)
    	self.walkableTiles = options[:walkableTiles] || [32,34,88,126,288,290,344,382] # This is temporary until Tiles class is developed
    	self.itemTiles = options[:itemTiles] || [42,102,109,298,358,365] # This is temporary until Items class references its x,y position
  	end

  	def save_state(seed,total_bunkers,items,walkable,all_items,all_beacons,all_bunkers)
		all_the_data = {}
		seed_json = {"seed" => seed}
		total_bunkers_json = {"total_bunkers" => total_bunkers}
		items_json = {"items" => items}
		walkable_json = {"walkable" => walkable}
		all_items_json = {"all_items" => all_items}
		all_beacons_json = {"beacons" => all_beacons}
		bunkers_json = {"bunkers" => all_bunkers}	  
		actors_json = {"actors" => Character.all_instances}

		all_the_data.merge!(seed_json)
		all_the_data.merge!(total_bunkers_json)
		all_the_data.merge!(items_json)
		all_the_data.merge!(walkable_json)
		all_the_data.merge!(all_items_json)
		all_the_data.merge!(all_beacons_json)
		all_the_data.merge!(bunkers_json)
		all_the_data.merge!(actors_json)

		# Save data to JSON
		File.open('save.json', 'w') do |f|    
			f.puts Oj::dump all_the_data
		    f.close
		end
	end

	def time_increase(timed)  
	  if timed[1] < 59 && timed[0] < 24
	    timed[1] += 1
	  elsif timed[0] == 23 && timed[1] == 59
	    timed[0] == 0
	    timed[1] == 0
	  else
	    timed[0] += 1
	    timed[1] = 0
	  end 
	end

	def scr_message(message,bars)
	  loading = "[" + "=" * bars + " " * (7 - bars) + "]"
	  Ncurses.mvwaddstr(stdscr, 2, 2, "Initializing Game")
	  Ncurses.mvwaddstr(stdscr, 3, 3, "#{message}")
	  Ncurses.mvwaddstr(stdscr, 4, 4, "#{loading}")
	  Ncurses.refresh
	  Ncurses.napms(0500)
	  Ncurses.clear
	end
end
