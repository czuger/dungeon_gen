module MovementInDungeon

  def movement_loop
    loop do

      puts 'Enter order : u<n>, d<n>, l<n>, r<n>'
      order = gets.chomp
      puts order.inspect

      if %w( u d l r ).include?( order[0] )

        @temporary_pos.move( order )
        @last_pos = @current_pos
        @current_pos = @temporary_pos

        print_dungeon_bmp

      else
        puts 'Unknown order'
      end
    end
  end
end