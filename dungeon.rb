class Dungeon

  POSITIONS = [ :top, :bottom, :left, :right ]

  def initialize
    @cases = {}
    @position = [ 0, 0, POSITIONS.sample ]
    create_room
    print_dungeon
  end

  def print_dungeon
    min_w = @cases.keys.map{ |k| k[ 0 ] }.min
    min_h = @cases.keys.map{ |k| k[ 1 ] }.min
    max_w = @cases.keys.map{ |k| k[ 0 ] }.max
    max_h = @cases.keys.map{ |k| k[ 1 ] }.max

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( min_h .. max_h ).each do |h|
        line = ''
        ( min_w .. max_w ).each do |w|
          if @cases[ [ w, h ] ] && @cases[ [ w, h ] ] == :rock
            line << '#'
          else
            line << ' '
          end
        end
        file.puts( line )
      end
    end
  end

  private

  def create_room
    height = rand( 4 .. 8 )
    width = rand( 4 .. 8 )

    # Place room tiles
    ( 1 .. height ).each do |h|
      ( 1 .. width ).each do |w|
        @cases[ [ w, h ] ] = :room unless @cases.has_key?( [ w, h ] )
      end
    end

    # Create rock around
    ( 0 .. height + 1 ).each do |h|
      ( 0 .. width + 1 ).each do |w|
        @cases[ [ w, h ] ] = :rock unless @cases.has_key?( [ w, h ] )
      end
    end

    set_entry( height, width )
  end

  def set_entry( height, width )
    pos = @position[ 2 ]
    puts pos

    if pos == :top
      entry_w = rand( ( 1 .. width-1 ) )
      entry_h = 0
    elsif pos == :bottom
      entry_w = rand( ( 1 .. width-1 ) )
      entry_h = height + 1
    elsif pos == :left
      entry_h = rand( ( 1 .. height-1 ) )
      entry_w = 0
    elsif pos == :right
      entry_h = rand( ( 1 .. height-1 ) )
      entry_w = width + 1
    end

    # Carve an entry
    @cases[ [ entry_w, entry_h ] ] = :room

    if pos == :top || pos == :bottom
      if entry_w + 1 >= width + 1
        entry_w -= 1
      else
        entry_w += 1
      end
    else
      if entry_h + 1 >= height + 1
        entry_h -= 1
      else
        entry_h += 1
      end
    end

    # Carve an entry
    @cases[ [ entry_w, entry_h ] ] = :room

  end
end

Dungeon.new