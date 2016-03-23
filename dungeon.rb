require 'pp'
require_relative 'exits'
require_relative 'position'
require_relative 'dungeon_ascii_print'
require_relative 'rooms/rect_room'
require_relative 'rooms/rooms_connection'
require_relative 'dungeon_bmp_print'

class Dungeon

  include DungeonAsciiPrint
  include DungeonBmpPrint
  include RoomsConnection

  attr_reader :current_room

  def initialize( nb_rooms )
    @rooms_keys = []
    @rooms = []
    @hallways = []

    while( @rooms.count < nb_rooms ) do
      room = RectRoom.new( nb_rooms )
      if ( @rooms_keys & room.room_hash_keys_footprint ).empty?
        @rooms << room
        @rooms_keys += room.room_hash_keys_footprint
      end
    end

    connect_rooms

  end

  def elements_to_cases
    @cases = {}
    @rooms.each do |room|
      room.set_cases( @cases )
    end
    @hallways.each do |hallway|
      hallway.set_cases( @cases )
    end
  end

  # def move_into_dungeon( exit_number )
  #   @current_position = @current_room.exits.get_exit_by_no( exit_number )
  #   puts 'Entrez la direction de la porte (0 = top, 1 = bottom, 2 = left, 3 = right)'
  #   num = gets.chomp
  #   @current_position.set_direction( num.to_i )
  #   @current_room = Room.new( self, @current_position )
  # end

  def compute_dungeon_corners
    @d_top_left_x = @d_top_left_y = @d_bottom_right_x = @d_bottom_right_y = 0
    @rooms.each do |room|
      top_left_x, top_left_y, bottom_right_x, bottom_right_y = room.room_corners

      @d_top_left_x = top_left_x if top_left_x < @d_top_left_x
      @d_top_left_y = top_left_y if top_left_y < @d_top_left_y

      @d_bottom_right_x = bottom_right_x if bottom_right_x > @d_bottom_right_x
      @d_bottom_right_y = bottom_right_y if bottom_right_y > @d_bottom_right_y
    end
  end

end

d = Dungeon.new( 15 )
d.print_dungeon_ascii
# d.print_dungeon_bmp

