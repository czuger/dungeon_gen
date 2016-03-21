require 'rmagick'

module DungeonOutput

  SIZE = 100

  def print_dungeon

    maxw = @min_w.abs + @max_w.abs + 1
    maxh = @min_h.abs + @max_h.abs + 1

    canvas = Magick::Image.new( maxw * SIZE, maxh * SIZE )

    gc = Magick::Draw.new
    gc.stroke( 'darkslateblue' )
    gc.fill( 'white' )

    # gc.rectangle( 10, 10, 50, 50 )

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( @min_h.to_i .. @max_h.to_i ).each do |h|
        line = ''
        ( @min_w.to_i .. @max_w.to_i ).each do |w|
          position_hash_key = Position.new( w, h ).hash_key

          if position_hash_key == @current_position.hash_key
            line << 'X'
            draw_case( gc, w, h )
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :rock
            line << '#'
            draw_case( gc, w, h, true )
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :room
            line << '.'
            draw_case( gc, w, h )
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ].is_a?( Integer )
            line << @cases[ position_hash_key ].to_s
            draw_case( gc, w, h )
          else
            line << ' '
            draw_case( gc, w, h, true )
          end
        end
        file.puts( line )
      end
    end

    # gc.rectangle( 10, 10, 500, 500 )

    gc.draw( canvas )
    canvas.write( 'dungeon.bmp' )
  end

  private

  def draw_case( gc, w, h, plain = false )
    gc.fill( 'darkslateblue' ) if plain
    minx = ( w - @min_w ) * SIZE
    maxx = ( w - @min_w + 1 ) * SIZE
    miny = ( h - @min_h ) * SIZE
    maxy = ( h - @min_h + 1 ) * SIZE
    gc.rectangle( minx, miny, maxx, maxy )

    gc.line( minx + SIZE / 2, miny, minx + SIZE / 2, maxy )
    gc.line( minx, miny + SIZE / 2, maxx, miny + SIZE / 2 )

    gc.fill( 'white' )
  end

end