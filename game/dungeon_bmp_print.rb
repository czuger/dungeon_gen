require 'rmagick'

module DungeonBmpPrint

  SIZE = 100

  def print_dungeon_bmp

    compute_dungeon_corners
    elements_to_cases

    x_distance = @d_top_left_x.abs + @d_bottom_right_x.abs + 1
    y_distance = @d_top_left_y.abs + @d_bottom_right_y.abs + 1

    canvas = Magick::Image.new( x_distance * SIZE, y_distance * SIZE )

    gc = Magick::Draw.new
    gc.stroke( 'darkslateblue' )
    gc.fill( 'white' )

    true_minx = nil
    true_maxx = nil
    true_miny = nil
    true_maxy = nil

    # gc.rectangle( 10, 10, 50, 50 )

    ( @d_top_left_y.to_i .. @d_bottom_right_y.to_i ).each do |h|
      ( @d_top_left_x.to_i .. @d_bottom_right_x.to_i ).each do |w|
        position = Position.new( w, h )

        if position.distance( @current_pos ) < 10 || position.distance( @last_pos ) < 10
          position_hash_key = position.hash_key

          if @cases[ position_hash_key ] && @cases[ position_hash_key ] == :wall
            true_minx, true_maxx, true_miny, true_maxy = draw_case( gc, w, h, [ true_minx, true_maxx, true_miny, true_maxy ], true )
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :floor
            true_minx, true_maxx, true_miny, true_maxy = draw_case( gc, w, h, [ true_minx, true_maxx, true_miny, true_maxy ] )
            if @dungeon_content[ position_hash_key ]
              print_text( gc, position, @dungeon_content[ position_hash_key ] ) unless @dungeon_content[ position_hash_key ].empty?
            end
          else
            true_minx, true_maxx, true_miny, true_maxy = draw_case( gc, w, h, [ true_minx, true_maxx, true_miny, true_maxy ], true )
          end
        end
      end
    end

    ( @d_top_left_y.to_i .. @d_bottom_right_y.to_i ).each do |h|
      ( @d_top_left_x.to_i .. @d_bottom_right_x.to_i ).each do |w|
        position = Position.new( w, h )
        if position.distance( @current_pos ) < 10 || position.distance( @last_pos ) < 10
          position_hash_key = position.hash_key
          if @dungeon_content[ position_hash_key ]
            print_text( gc, position, @dungeon_content[ position_hash_key ] ) unless @dungeon_content[ position_hash_key ].empty?
          end
        end
      end
    end

    # gc.rectangle( 10, 10, 500, 500 )

    draw_pos( gc )

    gc.draw( canvas )

    # puts true_minx, true_maxx, true_miny, true_maxy
    canvas.crop!( true_minx, true_miny, true_maxx - true_minx, true_maxy - true_miny )

    canvas.write( 'out/dungeon.jpg' )
  end

  private

  def print_text( gc, position, text )
    x = ( position.x - @d_top_left_x.to_i + 0.5 - 0.25 ) * SIZE
    y = ( position.y - @d_top_left_y.to_i + 0.5 + 0.25 ) * SIZE
    gc.pointsize = 80
    gc.fill( 'black' )
    puts text.join( '' ).inspect
    gc.text( x, y, text.join( '' ) )
    gc.fill( 'white' )
  end

  def draw_pos( gc )
    x = ( @current_pos.x - @d_top_left_x.to_i + 0.5 ) * SIZE
    y = ( @current_pos.y - @d_top_left_y.to_i + 0.5 ) * SIZE
    gc.fill( 'red' )
    gc.circle( x, y, x + SIZE / 4, y + SIZE / 4 )
  end

  def draw_case( gc, w, h, image_borders, plain = false )
    gc.fill( 'darkslateblue' ) if plain
    minx = ( w - @d_top_left_x ) * SIZE
    maxx = ( w - @d_top_left_x + 1 ) * SIZE
    miny = ( h - @d_top_left_y ) * SIZE
    maxy = ( h - @d_top_left_y + 1 ) * SIZE

    true_minx, true_maxx, true_miny, true_maxy = *image_borders

    true_minx = minx if !true_minx || true_minx > minx
    true_maxx = maxx if !true_maxx || true_maxx < maxx

    true_miny = miny if !true_miny || true_miny > miny
    true_maxy = maxy if !true_maxy || true_maxy < maxy

    gc.rectangle( minx, miny, maxx, maxy )

    gc.line( minx + SIZE / 2, miny, minx + SIZE / 2, maxy )
    gc.line( minx, miny + SIZE / 2, maxx, miny + SIZE / 2 )

    gc.fill( 'white' )

    [ true_minx, true_maxx, true_miny, true_maxy ]
  end

end