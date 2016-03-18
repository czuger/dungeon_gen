require 'pp'
require_relative 'rooms'
require_relative 'exits'
require_relative 'position'

class Dungeon

  include Rooms
  include Exits

  def initialize
    @cases = {}

    @position = Position.new
    @exits = []
  end

  def print_dungeon

    # pp @cases

    min_w = @cases.keys.map{ |k| k[ 0 ] }.min
    min_h = @cases.keys.map{ |k| k[ 1 ] }.min
    max_w = @cases.keys.map{ |k| k[ 0 ] }.max
    max_h = @cases.keys.map{ |k| k[ 1 ] }.max

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( min_h .. max_h ).each do |h|
        line = ''
        ( min_w .. max_w ).each do |w|
          if @cases[ [ w, h ] ] && @cases[ [ w, h ] ] == :rock
            line << '#'
          else
            line << '.'
          end
        end
        file.puts( line )
      end
    end
  end

end

d = Dungeon.new
d.create_room
d.print_dungeon

