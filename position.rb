class Position

  attr_reader :w, :h, :direction

  DIRECTIONS = [ :top, :bottom, :left, :right ]

  def initialize( w = 0, h = 0, direction = nil )
    @w = w
    @h = h
    @direction = direction if direction
  end

  def d
    @direction
  end

  def room_extension
    if d == :left || d == :right
      Position.new( @w-1, @h, @direction )
    elsif d == :top | d == :bottom
      Position.new( @w, @h-1, @direction )
    else
      raise "Position invalid : #{d}"
    end
  end

end