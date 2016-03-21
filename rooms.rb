require_relative 'exits'

class Room

  include Exits

  def initialize( dungeon, door_position )

    @dungeon = dungeon
    @door_position = door_position
    orientation = @door_position.d

    room_height = rand( 4 .. 12 )
    room_width = rand( 4 .. 12 )

    walls_for_exit= []

    @dungeon.create_room( @door_position )

    if [ :top, :bottom ].include?( orientation )
      lines = orientation == :top ? ( 0 ... room_height ) : 0.downto( -room_height+1 )
      lines.each do |h|
        drawed_walls = draw_line( door_position.h + h, room_width, h == 0 || h == room_height-1 || h == -room_height+1 )
        walls_for_exit += drawed_walls unless ( ( orientation == :top || orientation == :bottom ) && h == 0 ) # We dont carve exits on the side we are coming from
      end
    else
      columns = orientation == :left ? ( 0 ... room_width ) : 0.downto( -room_width+1 )
      columns.each do |w|
        drawed_walls += draw_column( room_height, door_position.w + w, w == 0 || w == room_width-1 || w == -room_width+1 )
        walls_for_exit += drawed_walls unless ( ( orientation == :left || orientation == :right ) && h == 0 ) # We dont carve exits on the side we are coming from
      end
    end

    create_exits( dungeon, walls_for_exit.shuffle )
  end

  private

  def draw_column( height, room_width, plain )
    low_border = -(height/2.0).ceil
    high_border = (height/2.0).ceil
    walls_for_exit= []

    ( low_border ... high_border ).each do |h|
      pos = Position.new( room_width, @door_position.h + h )

      fill = plain || [ low_border, high_border - 1 ].include?( h )
      object_created = fill ? @dungeon.create_wall( pos ) : @dungeon.create_room( pos )

      walls_for_exit<< pos if fill && object_created
    end
    walls_for_exit
  end

  def draw_line( height, room_width, plain )
    low_border = -(room_width/2.0).ceil
    high_border = (room_width/2.0).ceil
    walls_for_exit= []

    ( low_border ... high_border ).each do |w|
      pos = Position.new( @door_position.w + w, height )

      fill = plain || [ low_border, high_border - 1 ].include?( w )
      object_created = fill ? @dungeon.create_wall( pos ) : @dungeon.create_room( pos )

      walls_for_exit<< pos if fill && object_created
    end
    walls_for_exit
  end
end