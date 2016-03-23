require_relative 'room'

class Hallway < Room

  # TODO : have a look there http://www.gamasutra.com/blogs/AAdonaac/20150903/252889/Procedural_Dungeon_Generation_Algorithm.php
  # They explain how to make cornered hallways

  def initialize( room1, room2 )

    super()

    # try to create a straight hallway
    mp = get_rooms_midpoint( room1, room2 )
    top_left_x_1, top_left_y_1, bottom_right_x_1, bottom_right_y_1 = room1.room_corners
    top_left_x_2, top_left_y_2, bottom_right_x_2, bottom_right_y_2 = room2.room_corners

    # We can draw a vertical hallway
    if mp.x > room1.top_left_x && mp.x > room2.top_left_x && mp.x < room1.bottom_right_x && mp.x < room2.bottom_right_x
      draw_vertical_hallway( room1, room2 )
    elsif mp.y > room1.top_left_y && mp.y > room2.top_left_y && mp.y < room1.bottom_right_y && mp.y < room2.bottom_right_y
      draw_horizontal_hallway( room1, room2 )
    end

  end

  private

  def draw_horizontal_hallway( room1, room2 )
    if room1.top_left_y < room2.top_left_y
      left_room = room1
      right_room = room2
    else
      left_room = room2
      right_room = room1
    end

    # Find the commons y coords
    common_y_coords = room1.room_y_coords & room2.room_y_coords
    y_connection_point = common_y_coords.sort[ common_y_coords.count / 2 ]

    bottom_right_x_t = left_room.bottom_right_x
    top_left_x_b = right_room.top_left_x

    ( y_connection_point - 1 .. y_connection_point + 1 ).each do |y|
      ( bottom_right_x_t .. top_left_x_b ).each do |x|
        @elements << RoomElement.new(Position.new( x, y ), y == y_connection_point ? :floor : :wall )
      end
    end
  end

  def draw_vertical_hallway( room1, room2 )
    if room1.top_left_y < room2.top_left_y
      top_room = room1
      bottom_room = room2
    else
      top_room = room2
      bottom_room = room1
    end

    # Find the commons x coords
    common_x_coords = room1.room_x_coords & room2.room_x_coords
    x_connection_point = common_x_coords.sort[ common_x_coords.count / 2 ]

    bottom_right_y_t = top_room.bottom_right_y
    top_left_y_b = bottom_room.top_left_y

    ( x_connection_point - 1 .. x_connection_point + 1 ).each do |x|
      ( bottom_right_y_t .. top_left_y_b ).each do |y|
        @elements << RoomElement.new(Position.new( x, y ), x == x_connection_point ? :floor : :wall )
      end
    end
  end

  def get_rooms_midpoint( room1, room2 )
    c1 = room1.room_center
    c2 = room2.room_center
    Position.new( ( c1.x + c2.x ) / 2, ( c1.y + c2.y ) / 2 )
  end
end