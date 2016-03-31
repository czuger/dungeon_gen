require 'io/console'

module MovementInDungeon

  def movement_loop
    # state = `stty -g`
    # `stty raw -echo -icanon isig`

    while true
      c = read_char

      @last_pos = @current_pos.clone
      unless @current_pos.move( c )
        if c == 'k'
          kill_monsters
        elsif c == 'd'
          disarm_traps
        else
          puts 'Bad order !!!'
        end
      end
      print_dungeon_bmp
    end

  end

  def disarm_traps
    @dungeon_content.each_pair do |key, values|
      next unless values.include?( 'T' )
      trap_pos = Position.from_hash_key( key )
      distance = trap_pos.distance( @current_pos )
      if distance < Dungeon::WATCH_DISTANCE
        @dungeon_content[ key ].delete( 'T' )
      end
    end
  end

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

  private

  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

end