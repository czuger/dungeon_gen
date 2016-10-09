require 'rmagick'
require_relative 'dungeon_bmp_print_picture_size'
require_relative 'get_line_of_sight'

module DungeonBmpPrint

  include GetLineOfSight

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

    @picture_size.each_case do |position|

      if position.distance( @current_pos ) < Dungeon::WATCH_DISTANCE || position.distance( @last_pos ) < Dungeon::WATCH_DISTANCE
        position_hash_key = position.hash_key
        if @dungeon_content[ position_hash_key ]
          unless @dungeon_content[ position_hash_key ].empty?
            print_text( gc, position, @dungeon_content[ position_hash_key ] )
          end
        end
      end

    end

    draw_pos( gc )
    gc.draw( canvas )
    canvas.write( 'out/dungeon.jpg' )
  end

  private

  def print_text( gc, position, text )
    position = @picture_size.decal_case( position )
    x = ( position.x + 0.5 - 0.25 ) * DungeonBmpPrintPictureSize::SIZE
    y = ( position.y + 0.5 + 0.25 ) * DungeonBmpPrintPictureSize::SIZE
    gc.pointsize = 50
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

    pos = Position.new( w, h )
    show_monster = pos.distance( @current_pos ) < Dungeon::WATCH_DISTANCE && @dungeon_content[ pos.hash_key ]
    print_distance( gc, pos ) unless plain || show_monster
  end

  def print_distance( gc, pos )
    if @current_pos.x == pos.x
      if @current_pos.y > pos.y
        print_text( gc, pos, [ "U#{((@current_pos.y-pos.y)*2).to_i}" ] )
      else
        print_text( gc, pos, [ "D#{((pos.y-@current_pos.y)*2).to_i}" ] )
      end
    end

    if @current_pos.y == pos.y
      if @current_pos.x > pos.x
        print_text( gc, pos, [ "L#{((@current_pos.x-pos.x)*2).to_i}" ] )
      else
        print_text( gc, pos, [ "R#{((pos.x-@current_pos.x)*2).to_i}" ] )
      end
    end
  end

end