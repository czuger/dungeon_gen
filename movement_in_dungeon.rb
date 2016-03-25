module MovementInDungeon

  def movement_loop
    loop do

      puts 'Enter order : t<n>, b<n>, l<n>, r<n>, f'
      order = gets.chomp
      puts order.inspect

      if order[0] == 'f'
        puts @rooms.first.room_center.inspect
        puts @last_pos.inspect, @current_pos.inspect, @temporary_pos.inspect,
        @last_pos = @current_pos
        @current_pos = @temporary_pos
        print_dungeon_bmp
      elsif %w( t b l r ).include?( order[0] )
        @temporary_pos.move( order )
      else
        puts 'Unknown order'
      end
    end
  end
end