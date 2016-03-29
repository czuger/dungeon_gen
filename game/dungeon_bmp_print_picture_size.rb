class DungeonBmpPrintPictureSize

  SIZE = 100
  PICTURE_POS_EXTENT = 5

  def initialize( current_pos, last_pos )

    # pp current_pos, last_pos

    @data = {
      case: {
        x: {
          min: [ current_pos.x, last_pos.x ].min - PICTURE_POS_EXTENT,
          max: [ current_pos.x, last_pos.x ].max + PICTURE_POS_EXTENT
        },
        y: {
          min: [ current_pos.y, last_pos.y ].min - PICTURE_POS_EXTENT,
          max: [ current_pos.y, last_pos.y ].max + PICTURE_POS_EXTENT
        }
      }
    }

    @data[ :coord ] = {} unless @data[ :coord ]
    ( :x .. :y ).each do |coord|
      [ :min, :max ].each do |function|
        @data[ :coord ][ coord ] = {} unless @data[ :coord ][ coord ]
        @data[ :coord ][ coord ][ function ] = {} unless @data[ :coord ][ coord ][ function ]
        @data[ :coord ][ coord ][ function ] = @data[ :case ][ coord ][ function ] * SIZE
      end
    end

    # pp self

  end

  def each_case
    ( get_val( :case, :y, :min ).floor .. get_val( :case, :y, :max ).ceil ).each do |y|
      ( get_val( :case, :x, :min ).floor .. get_val( :case, :x, :max ).ceil ).each do |x|
        position = Position.new( x, y )
        yield position
      end
    end
  end

  def decal_case( position )
    Position.new( position.x - get_val( :case, :x, :min ), position.y - get_val( :case, :y, :min ) )
  end

  def decal_position( position )
    Position.new( position.x - get_val( :coord, :x, :min ), position.y - get_val( :coord, :y, :min ) )
  end

  def width
    get_extent( :x )
  end

  def height
    get_extent( :y )
  end

  private

  def get_extent( coord )
    get_val( :coord, coord, :max ) - get_val( :coord, coord, :min )
  end

  def get_val( type, coord, function )
    @data[ type ][ coord ][ function ]
  end

end