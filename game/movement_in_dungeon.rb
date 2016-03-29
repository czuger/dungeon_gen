require 'io/console'

module MovementInDungeon

  def movement_loop
    state = `stty -g`
    `stty raw -echo -icanon isig`

    while true
      c = STDIN.getch

      @last_pos = @current_pos.clone
      @current_pos.move( c )
      print_dungeon_bmp
    end

  end

  # TODO : need to rework on monster management + adapt screen

  # def movement_loop
  #   loop do
  #
  #     puts 'Enter order : u<n>, d<n>, l<n>, r<n>, k'
  #     order = gets.chomp
  #     # puts order.inspect
  #
  #     if %w( u d l r ).include?( order[0] )
  #       @last_pos = @current_pos.clone
  #       @current_pos.move( order )
  #       puts @last_pos.inspect
  #       puts @current_pos.inspect
  #     elsif order[0] == 'k'
  #       kill_monsters
  #     else
  #       puts 'Unknown order'
  #     end
  #
  #     print_dungeon_bmp
  #
  #   end
  # end

  def kill_monsters
    @dungeon_content.each_pair do |key, values|
      next unless values.include?( 'M' )
      monster_pos = Position.from_hash_key( key )
      distance = monster_pos.distance( @current_pos )
      if distance < Dungeon::WATCH_DISTANCE
        @dungeon_content[ key ].delete( 'M' )
      end
    end
  end

end