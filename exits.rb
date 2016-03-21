class Exits

  def initialize( dungeon, walls )
    @exits = []

    exits = rand( 1 .. 3 )
    1.upto( exits ).each do |exit_number|
      position = walls.shift
      if position
        dungeon.carve_door( position, exit_number )
        @exits << position

        # Remove all near position
        walls.reject!{ |e| position.distance( e ) < 3 }
      end
    end
  end

  def print_exits
    # pp @exits
    puts 'Which exit do you want to take ? (see map)'
    1.upto( @exits.count ) do |exit_no|
      puts "#{exit_no}"
    end
  end

  def get_exit_by_no( exit_number )
    @exits[ exit_number.to_i-1 ]
  end

end