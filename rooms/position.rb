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

  def adjacent_positions
    adj_pos = []
    ( -1 .. 1 ).each do |xadd|
      ( -1 .. 1 ).each do |yadd|
        adj_pos << Position.new( x + xadd, y + yadd )
      end
    end
    adj_pos
  end

  def hash_key
    "#{x}_#{y}"
  end

  def self.from_hash_key( hash_key )
    # puts hash_key.inspect
    x, y = hash_key.split( '_' )
    Position.new( x.to_i, y.to_i )
  end

  def d
    raise "#{self.class}##{__method__} : @direction not defined" unless @direction
    @direction
  end

  def move( order )
    good_order = true
    command = order
    amount = 1
    # puts order.inspect
    if command == "\e[A"
      @y -= amount
    elsif command == "\e[B"
      @y += amount
    elsif command == "\e[D"
      @x -= amount
    elsif command == "\e[C"
      @x += amount
    else
      good_order = false
    end
    good_order
  end
end