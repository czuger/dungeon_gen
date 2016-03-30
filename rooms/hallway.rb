require_relative 'room'

class Hallway < Room

  # TODO : have a look there http://www.gamasutra.com/blogs/AAdonaac/20150903/252889/Procedural_Dungeon_Generation_Algorithm.php
  # They explain how to make cornered hallways
  attr_reader :hallway_floors_positions

  def initialize( dungeon, room1, room2 )

    super()

    @dungeon = dungeon
    # For traps
    @hallway_floors_positions = []

    # try to create a straight hallway
    mp = get_rooms_midpoint( room1, room2 )
    # @elements << RoomElement.new( mp, :wall ) unless @dungeon.case_occuped?( mp.hash_key )

    # We can draw a vertical hallway
    if mp.x > room1.top_left_x && mp.x > room2.top_left_x && mp.x < room1.bottom_right_x && mp.x < room2.bottom_right_x
      draw_vertical_hallway_between_rooms( room1, room2 )
      #  We can draw a horizontal hallway
    elsif mp.y > room1.top_left_y && mp.y > room2.top_left_y && mp.y < room1.bottom_right_y && mp.y < room2.bottom_right_y
      draw_horizontal_hallway_between_rooms( room1, room2 )
    else
      draw_cornered_hallway( room1, room2, mp )
    end

  end

  private

  def draw_cornered_hallway( room1, room2, mp )
    if room1.room_center.y > mp.y
      top_room = room1
    else
      top_room = room2
    end
    bottom_room = ( [ room1, room2 ] - [ top_room ] ).first
    raise "#{self.class}##{__method__} : bottom_room and top_room are the same" if top_room == bottom_room
    draw_vertical_hallway_between_positions( top_room.room_center, Position.new( top_room.room_center.x, bottom_room.room_center.y ) )
    draw_horizontal_hallway_between_positions( bottom_room.room_center, Position.new( top_room.room_center.x, bottom_room.room_center.y ) )
  end

  def draw_horizontal_hallway_between_rooms( room1, room2 )
    # Find the commons y coords
    common_y_coords = room1.room_y_coords & room2.room_y_coords
    y_connection_point = common_y_coords.sort[ common_y_coords.count / 2 ]

    draw_horizontal_hallway_between_positions(
      Position.new( room1.room_center.x, y_connection_point ), Position.new( room2.room_center.x, y_connection_point ) )
  end

  def draw_vertical_hallway_between_rooms(room1, room2 )
    # Find the commons x coords
    common_x_coords = room1.room_x_coords & room2.room_x_coords
    x_connection_point = common_x_coords.sort[ common_x_coords.count / 2 ]

    draw_vertical_hallway_between_positions(
      Position.new( x_connection_point, room1.room_center.y ), Position.new( x_connection_point, room2.room_center.y ) )
  end

  def draw_vertical_hallway_between_positions( pos_1, pos_2 )
    raise "#{self.class}##{__method__} : #{pos_1} and #{pos_2} does not share an x position" unless pos_1.x == pos_2.x

    miny = [ pos_1.y, pos_2.y ].min
    maxy = [ pos_1.y, pos_2.y ].max

    ( pos_1.x - 1 .. pos_1.x + 1 ).each do |x|
      ( miny .. maxy ).each do |y|
        p = Position.new( x, y )
        if x == pos_1.x
          @elements << RoomElement.new( p, :floor )
          @hallway_floors_positions << p
        else
          @elements << RoomElement.new( p, :wall ) unless @dungeon.case_occuped?( p.hash_key )
        end
        @dungeon.set_case_occuped( p )
      end
    end
  end

  def draw_horizontal_hallway_between_positions( pos_1, pos_2 )
    raise "#{self.class}##{__method__} : #{pos_1} and #{pos_2} does not share an y position" unless pos_1.y == pos_2.y

    minx = [ pos_1.x, pos_2.x ].min
    maxx = [ pos_1.x, pos_2.x ].max

    ( pos_1.y - 1 .. pos_1.y + 1 ).each do |y|
      ( minx .. maxx ).each do |x|
        p = Position.new( x, y )
        if y == pos_1.y
          @elements << RoomElement.new( p, :floor )
          @hallway_floors_positions << p
        else
          p = Position.new( x, y )
          @elements << RoomElement.new( p, :wall ) unless @dungeon.case_occuped?( p.hash_key )
        end
        @dungeon.set_case_occuped( p )
      end
    end
  end

  def get_rooms_midpoint( room1, room2 )
    c1 = room1.room_center
    c2 = room2.room_center
    Position.new( ( c1.x + c2.x ) / 2, ( c1.y + c2.y ) / 2 )
  end
end