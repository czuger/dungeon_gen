module Exits

  private

  def create_exits( walls )

    exits = rand( 1 .. 3 )
    1.upto( exits ).each do
      position = walls.shift
      create_exit( wall )
    end
  end

  def create_exit( w, h )
    @cases[ [ w, h ] ] = :room
  end
end