class Position

  attr_reader :w, :h

  DIRECTIONS = [ :top, :bottom, :left, :right ]

  def initialize( w = 0, h = 0, direction = nil )
    @w = w
    @h = h
    @direction = direction if direction
  end

  def distance( position )
    Math.sqrt( ( w - position.w )**2 + ( h - position.h )**2 ).round( 0 )
  end

  def set_direction( direction_nb )
    @direction = DIRECTIONS[ direction_nb ]
  end

  def ==( position )
    self.w == position.w && self.h == position.h
  end

  def hash_key
    "#{w}_#{h}"
  end

  def d
    raise "#{self.class}##{__method__} : @direction not defined" unless @direction
    @direction
  end

end