class Position

  attr_reader :x, :y

  DIRECTIONS = [ :top, :bottom, :left, :right ]

  def initialize( x, y, direction = nil )
    @x = x
    @y = y
    @direction = direction if direction
  end

  def distance( position )
    Math.sqrt( ( x - position.x )**2 + ( y - position.y )**2 ).round( 0 )
  end

  def set_direction( direction_nb )
    @direction = DIRECTIONS[ direction_nb ]
  end

  def ==( position )
    self.x == position.x && self.y == position.y
  end

  def hash_key
    "#{x}_#{y}"
  end

  def d
    raise "#{self.class}##{__method__} : @direction not defined" unless @direction
    @direction
  end

end