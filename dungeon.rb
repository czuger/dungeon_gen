require 'pp'
require_relative 'rooms'
require_relative 'exits'
require_relative 'position'
require_relative 'dungeon_output'

class Dungeon

  include DungeonOutput

  attr_reader :current_room

  def initialize
    @cases = {}

    @current_position = Position.new( 0, 0, :top )

    @min_w = Float::INFINITY
    @min_h = Float::INFINITY
    @max_w = -Float::INFINITY
    @max_h = -Float::INFINITY

    @current_room = Room.new( self, @current_position )
  end

  def carve_door( position, exit_number )
    @cases[ position.hash_key ] = exit_number
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

  def move_into_dungeon( exit_number )
    @current_position = @current_room.exits.get_exit_by_no( exit_number )
    puts 'Entrez la direction de la porte (0 = top, 1 = bottom, 2 = left, 3 = right)'
    num = gets.chomp
    @current_position.set_direction( num.to_i )
    @current_room = Room.new( self, @current_position )
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

while true
  d.print_dungeon
  d.current_room.exits.print_exits
  num = gets.chomp
  d.move_into_dungeon( num )
end

