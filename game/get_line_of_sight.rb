module GetLineOfSight

  def los_obstrued?( pos1, pos2, dungeon_cases )

    los_cases = bresenham( pos1, pos2 )

    los_cases.each do |c|
      if dungeon_cases[ c.hash_key ] == :wall
        return true
      end
    end
    false
  end

  private

  def bresenham( pos1, pos2 )

    x0 = pos1.x.round
    y0 = pos1.y.round
    x1 = pos2.x.round
    y1 = pos2.y.round

    points = []
    steep = ((y1-y0).abs) > ((x1-x0).abs)
    if steep
      x0,y0 = y0,x0
      x1,y1 = y1,x1
    end
    if x0 > x1
      x0,x1 = x1,x0
      y0,y1 = y1,y0
    end
    deltax = x1-x0
    deltay = (y1-y0).abs
    error = (deltax / 2).to_i
    y = y0
    ystep = nil
    if y0 < y1
      ystep = 1
    else
      ystep = -1
    end
    for x in x0..x1
      if steep
        points << Position.new( y, x )
      else
        points << Position.new( x, y )
      end
      error -= deltay
      if error < 0
        y += ystep
        error += deltax
      end
    end
    return points
  end

end
