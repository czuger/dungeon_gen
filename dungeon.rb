require 'pp'
require_relative 'rooms/position'
require_relative 'game/dungeon_ascii_print'
require_relative 'rooms/rect_room'
require_relative 'rooms/rooms_connection'
require_relative 'game/dungeon_bmp_print'
require_relative 'game/movement_in_dungeon'
require 'set'

class Dungeon

  include DungeonAsciiPrint
  include DungeonBmpPrint
  include RoomsConnection
  include MovementInDungeon

  WATCH_DISTANCE=4

  attr_reader :current_room

  def initialize( nb_rooms )

    superseed = nil
    superseed = 227363164522134968962419981135215379863
    seed = superseed ? superseed : Random.new_seed
    puts "Dungeon seed = #{seed}"
    srand( seed )

    # The cases really occuped by the room
    @occuped_cases = Set.new
    # The cases around the room to avoid accoladed rooms
    @room_phantom_cases = Set.new

    @rooms = []
    @hallways = []

    while( @rooms.count < nb_rooms ) do
      room = RectRoom.new( nb_rooms )
      if ( @occuped_cases & room.room_hash_keys_footprint ).empty? && ( @room_phantom_cases & room.room_hash_keys_phantom ).empty?
        @rooms << room
        @occuped_cases += room.room_hash_keys_footprint
        @room_phantom_cases += room.room_hash_keys_phantom
      end
    end

    connect_rooms

    @last_pos = @rooms.first.room_center.clone
    @current_pos = @rooms.first.room_center.clone

    # Set dungeon content
    @dungeon_content = {}

    # Monsters generation, each room has halve a chance of having a monster
    @rooms.each do |room|
      monster = @rooms.first != room && rand( 1 .. 2 ) == 1 ? 'M' : nil
      if monster
        @dungeon_content[ room.room_center.hash_key ] = [ monster ]
      end
    end

    # Treasure generation.
    # 10% chance of a trapped chest rather than a single treasure (still contain treasure)
    # C = Chest, mean trapped chest containing hoard, H = Hoard, mean non trapped hoard
    treasure_room = nil
    greatest_distance = -Float::INFINITY
    @rooms.each do |room|
      distance = @rooms.first.room_center.distance( room.room_center )
      if distance > greatest_distance
        greatest_distance = distance
        treasure_room = room
      end
    end
    treasure = rand( 1 .. 10 ) == 1 ? 'C' : 'H'
    @dungeon_content[ treasure_room.room_center.hash_key ] ||= []
    @dungeon_content[ treasure_room.room_center.hash_key ] << treasure

    # Traps generation
    @hallways.each do |hallway|
      trap = rand( 1 .. 5 ) == 1 ? 'T' : nil
      trap_position = hallway.hallway_floors_positions.sample
      @dungeon_content[ trap_position.hash_key ] = [] unless @dungeon_content[ trap_position.hash_key ]
      @dungeon_content[ trap_position.hash_key ] << trap if trap
    end

    # pp @dungeon_content

  end

  def case_occuped?( hash_key )
    @occuped_cases.include?(hash_key )
  end

  def set_case_occuped( pos )
    @occuped_cases << pos.hash_key
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

d = Dungeon.new( 16 )
d.print_dungeon_bmp

d.movement_loop

