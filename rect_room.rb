require_relative 'room_element'

class RectRoom

  def initialize( nb_rooms )
    distance = nb_rooms * 2
    @room_distance = rand( 1 .. distance )
    @room_angle = rand( 0 .. 2*Math::PI )

    @room_center = Position.new( (@room_distance * Math.cos( @room_angle )).round( 0 ), (@room_distance * Math.sin( @room_angle )).round( 0 ) )
    @room_height = rand( 4 .. 8 )
    @room_width = rand( 4 .. 8 )

    draw_room
  end

  def set_cases( cases )
    @room_elements.each do |element|
      cases[ element.position.hash_key ] = element.element_type
    end
  end

  def rooms_positions_keys
    @room_elements.map{ |r| r.position.hash_key }
  end

  def room_corners
    [ -(@room_height/2.0).ceil + @room_center.x, -(@room_width/2.0).ceil + @room_center.y,
      (@room_height/2.0).ceil + @room_center.x, (@room_width/2.0).ceil + @room_center.y ]
  end

  private

  def draw_room
    @room_elements = []

    top_left_x, top_left_y, bottom_right_x, bottom_right_y = room_corners

    ( top_left_x .. bottom_right_x ).each do |x|
      ( top_left_y .. bottom_right_y ).each do |y|
        room_element = :floor
        room_element = :wall if x == top_left_x || x == bottom_right_x || y == top_left_y || y == bottom_right_y
        @room_elements << RoomElement.new( Position.new( x, y ), room_element )
      end
    end
  end

end