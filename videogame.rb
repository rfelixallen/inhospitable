require_relative 'library'

class Videogame
=begin  
  attr_accessor :symb, :symbcode, :color, :xlines, :ycols, :blocked #:hp, :hunger, :inventory#, :weather
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.symbcode = options[:symbcode] || 64 # Should be whatever the ascii code for symb is 
    self.color = options[:color] || 1 # White
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.blocked = options[:blocked] || true
  end
=end
end