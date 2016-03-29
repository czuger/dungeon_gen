require 'rmagick'
require_relative 'dungeon_bmp_print_picture_size'
require_relative 'naive_line_of_sight'

module DungeonBmpPrint

  include NaiveLineOfSight

  def print_dungeon_bmp

    # compute_dungeon_corners
    elements_to_cases

    @picture_size = DungeonBmpPrintPictureSize.new( @current_pos, @last_pos )

    # x_distance = @d_top_left_x.abs + @d_bottom_right_x.abs + 1
    # y_distance = @d_top_left_y.abs + @d_bottom_right_y.abs + 1

    canvas = Magick::Image.new( @picture_size.width, @picture_size.height )

    gc = Magick::Draw.new
    gc.stroke( 'darkslateblue' )
    gc.fill( 'white' )

    # gc.rectangle( 10, 10, 50, 50 )

    @picture_size.each_case do |position|
      position_hash_key = position.hash_key

      if @cases[ position_hash_key ] && @cases[ position_hash_key ] == :wall
        draw_case( gc, position, true )
      elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :floor && !los_obstrued?( @current_pos, position, @cases )
        draw_case( gc, position )
      else
        draw_case( gc, position, true )
      end
    end

    # ( @d_top_left_y.to_i .. @d_bottom_right_y.to_i ).each do |h|
    #   ( @d_top_left_x.to_i .. @d_bottom_right_x.to_i ).each do |w|
    #     position = Position.new( w, h )
    #     if position.distance( @current_pos ) < Dungeon::WATCH_DISTANCE || position.distance( @last_pos ) < Dungeon::WATCH_DISTANCE
    #       position_hash_key = position.hash_key
    #       if @dungeon_content[ position_hash_key ]
    #         unless @dungeon_content[ position_hash_key ].empty?
    #           # puts position.distance( @current_pos )
    #           # puts position.distance( @last_pos )
    #           print_text( gc, position, @dungeon_content[ position_hash_key ] )
    #         end
    #       end
    #     end
    #   end
    # end

    # gc.rectangle( 10, 10, 500, 500 )

    draw_pos( gc )
    gc.draw( canvas )
    canvas.write( 'out/dungeon.jpg' )
  end

  private

  def print_text( gc, position, text )
    x = ( position.x - @d_top_left_x.to_i + 0.5 - 0.25 ) * SIZE
    y = ( position.y - @d_top_left_y.to_i + 0.5 + 0.25 ) * SIZE
    gc.pointsize = 80
    gc.fill( 'black' )
    # puts text.join( '' ).inspect
    gc.text( x, y, text.join( '' ) )
    gc.fill( 'white' )
  end

  def draw_pos( gc )
    decaled_current_pos = @picture_size.decal_case( @current_pos )
    x = ( decaled_current_pos.x + 0.5 ) * DungeonBmpPrintPictureSize::SIZE
    y = ( decaled_current_pos.y + 0.5 ) * DungeonBmpPrintPictureSize::SIZE

    gc.fill_opacity( 0 )
    gc.circle( x, y, x + ( DungeonBmpPrintPictureSize::SIZE * Dungeon::WATCH_DISTANCE ) / 2, y + ( DungeonBmpPrintPictureSize::SIZE * Dungeon::WATCH_DISTANCE / 2 ) )
    gc.fill_opacity( 1 )

    gc.fill( 'red' )
    gc.circle( x, y, x + DungeonBmpPrintPictureSize::SIZE / 4, y + DungeonBmpPrintPictureSize::SIZE / 4 )

  end

  def draw_case( gc, position, plain = false )

    # pp position
    position = @picture_size.decal_case( position )
    # pp position

    gc.fill( 'darkslateblue' ) if plain

    minx = position.x * DungeonBmpPrintPictureSize::SIZE
    maxx = ( position.x + 1 ) * DungeonBmpPrintPictureSize::SIZE
    miny = position.y * DungeonBmpPrintPictureSize::SIZE
    maxy = ( position.y + 1 ) * DungeonBmpPrintPictureSize::SIZE

    gc.rectangle( minx, miny, maxx, maxy )

    gc.line( minx + DungeonBmpPrintPictureSize::SIZE / 2, miny, minx + DungeonBmpPrintPictureSize::SIZE / 2, maxy )
    gc.line( minx, miny + DungeonBmpPrintPictureSize::SIZE / 2, maxx, miny + DungeonBmpPrintPictureSize::SIZE / 2 )

    gc.fill( 'white' )

  end

end