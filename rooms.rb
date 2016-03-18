module Rooms

  def create_room
    height = rand( 4 .. 12 )
    width = rand( 4 .. 12 )

    walls = []
    # Creating room main entry
    @cases[ @position ] = :room

    if [ :top, :bottom ].include?( @position.d )
      @cases[ @position.room_extension ] = :room

      lines = @position[ :pos ] == :top ? ( 0 ... height ) : 0.downto( -height+1 )
      lines.each do |h|
        walls += draw_line( @position[ :h ] + h, width, h == 0 || h == height-1 || h == -height+1 )
      end

    else
      @cases[ @position.room_extension ] = :room

      columns = @position.d == :left ? ( 0 ... width ) : 0.downto( -width+1 )
      columns.each do |w|
        walls += draw_column( height, @position.w + w, w == 0 || w == width-1 || w == -width+1 )
      end
    end

    #create_exits( height, width, walls.shuffle )
  end

  private

  def draw_column( height, width, plain )
    low_border = -(height/2.0).ceil
    high_border = (height/2.0).ceil
    walls = []

    ( low_border ... high_border ).each do |h|
      pos = Position.new( width, @position.h + h )
      unless @cases.has_key?( pos )
        fill = plain || [ low_border, high_border - 1 ].include?( h )

        direction = :left if plain &&

        @cases[ pos ] = fill ? :rock : :room
        walls << pos if fill
      end
    end
    walls
  end

  def draw_line( height, width, plain )
    low_border = -(width/2.0).ceil
    high_border = (width/2.0).ceil
    walls = []

    ( low_border ... high_border ).each do |w|
      pos = Position.new( @position.w + w, height )
      unless @cases.has_key?( [ @position.w + w, height ] )
        fill = plain || [ low_border, high_border - 1 ].include?( w )

        @cases[ pos ] = fill ? :rock : :room
        walls << pos if fill
      end
    end
    walls
  end
end