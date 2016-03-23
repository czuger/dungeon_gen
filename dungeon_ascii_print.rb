require 'rmagick'

module DungeonAsciiPrint

  SIZE = 100

  def print_dungeon_ascii

    compute_dungeon_corners
    elements_to_cases

    File.open( 'dungeon.txt', 'w' ) do |file|
      ( @d_top_left_y.to_i .. @d_bottom_right_y.to_i ).each do |h|
        line = ''
        ( @d_top_left_x.to_i .. @d_bottom_right_x.to_i ).each do |w|
          position_hash_key = Position.new( w, h ).hash_key

          if @cases[ position_hash_key ] && @cases[ position_hash_key ] == :wall
            line << '#'
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ] == :floor
            line << '.'
          elsif @cases[ position_hash_key ] && @cases[ position_hash_key ].is_a?( Integer )
            line << @cases[ position_hash_key ].to_s
          else
            line << ' '
          end
        end
        file.puts( line )
      end
    end

  end

end