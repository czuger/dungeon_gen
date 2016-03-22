require 'rmagick'

module DungeonAsciiPrint

  SIZE = 100

  def print_dungeon

    compute_dungeon_corners

    x_distance = @d_top_left_x.abs + @d_bottom_right_x.abs + 1
    y_distance = @d_top_left_y.abs + @d_bottom_right_y.abs + 1

    canvas = Magick::Image.new( x_distance * SIZE, y_distance * SIZE )

    gc = Magick::Draw.new
    gc.stroke( 'darkslateblue' )
    gc.fill( 'white' )

    # gc.rectangle( 10, 10, 50, 50 )

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( @d_top_left_y.to_i .. @d_bottom_right_y.to_i ).each do |h|
        line = ''
        ( @d_top_left_x.to_i .. @d_bottom_right_x.to_i ).each do |w|
          position_hash_key = Position.new( w, h ).hash_key

          if @cases[ position_hash_key ] && @cases[ position_hash_key ] == :rock
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
    minx = ( w - @d_top_left_x ) * SIZE
    maxx = ( w - @d_top_left_x + 1 ) * SIZE
    miny = ( h - @d_top_left_y ) * SIZE
    maxy = ( h - @d_top_left_y + 1 ) * SIZE
    gc.rectangle( minx, miny, maxx, maxy )

    gc.line( minx + SIZE / 2, miny, minx + SIZE / 2, maxy )
    gc.line( minx, miny + SIZE / 2, maxx, miny + SIZE / 2 )

    gc.fill( 'white' )
  end

end