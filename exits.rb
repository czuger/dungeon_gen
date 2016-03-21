module Exits

  private

  def create_exits( dungeon, walls )

    exits = rand( 1 .. 3 )
    1.upto( exits ).each do
      position = walls.shift
      dungeon.carve_door( position )
    end
  end

end