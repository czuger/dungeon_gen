require 'pp'
require_relative 'rooms'
require_relative 'exits'
require_relative 'position'

class Dungeon

  def initialize
    @cases = {}

    @start = Position.new( 0, 0, :top )
    @exits = []

    @min_w = Float::INFINITY
    @min_h = Float::INFINITY
    @max_w = -Float::INFINITY
    @max_h = -Float::INFINITY

    Room.new( self, @start )
  end

  def carve_door( position )
    @cases[ position.hash_key ] = :room
    update_min_max( position )
  end

  def create_room( position )
    unless @cases.has_key?( position.hash_key )
      @cases[ position.hash_key ] = :room
      update_min_max( position )
    end
  end

  def create_wall( position )
    unless @cases.has_key?( position.hash_key )
      @cases[ position.hash_key ] = :rock
      update_min_max( position )
      true
    end
  end

  def print_dungeon

    # pp self

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( @min_h.to_i .. @max_h.to_i ).each do |h|
        line = ''
        ( @min_w.to_i .. @max_w.to_i ).each do |w|
          position_hash_key = Position.new( w, h ).hash_key
          if @cases[ position_hash_key ] && @cases[ position_hash_key ] == :rock
            line << '#'
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :room
            line << '.'
          else
            line << '£'
          end
        end
        file.puts( line )
      end
    end
  end

  private

  def update_min_max( position )
    @min_w = position.w if position.w < @min_w
    @min_h = position.h if position.h < @min_h
    @max_w = position.w if position.w > @max_w
    @max_h = position.h if position.h > @max_h
  end

end

d = Dungeon.new
d.print_dungeon

