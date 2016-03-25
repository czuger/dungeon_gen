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

  def d
    raise "#{self.class}##{__method__} : @direction not defined" unless @direction
    @direction
  end

  def move( order )
    command, amount =  order.scan( /(\w)(\d+)/ ).first
    amount = amount.to_i / 2.0
    if command == 't'
      @y -= amount
    elsif command == 'b'
      @y += amount
    elsif command == 'l'
      @x -= amount
    elsif command == 'r'
      @x += amount
    else
      puts 'Bad order !!'
    end
  end

end