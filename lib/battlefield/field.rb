module Battlefield
  class Field
    attr_reader :size
    attr_reader :sectors
    attr_reader :occupied_sectors

    def initialize(size, fleet)
      @size, @fleet = size, fleet
      @sectors = []
      0.upto(size-1) do |y|
        @sectors[y] = []
        0.upto(size-1) do |x|
          @sectors[y] << Sector.new(x, y, :empty)
        end
      end
      @occupied_sectors = []
      @hit_sectors_size = @ship_sectors_size = 0
    end

    def deploy(ship, position, bearing)
      raise ArgumentError unless deployable?(ship, position, bearing)
      ship_sectors(ship, position, bearing).each do |sector|
        sector = @sectors[sector.x][sector.y]
        sector.state = :ship
        @occupied_sectors << sector
        @ship_sectors_size += 1
      end
    end

    def deployable?(ship, position, bearing)
      (occupied_sectors & ship_sectors(ship, position, bearing)).empty?  && in_bounds?(ship, position, bearing)
    end

    def ship_sectors(ship, position, bearing)
      sectors = []
      0.upto(ship.size - 1) do |i|
        x,y = position
        if bearing == :horizontal
          x += i
        else 
          y += i
        end
        sectors << Sector.new(x, y, :ship)
      end
      sectors
    end

    def in_bounds?(ship, position, bearing)
      stern_x,stern_y = position
      if bearing == :horizontal
        bow_x,bow_y = stern_x + ship.size - 1, stern_y
      else
        bow_x,bow_y = stern_x, stern_y + ship.size - 1
      end
      stern_x >= 0 && stern_y >= 0 && bow_x <= size-1 && bow_y <= size-1
    end

    def shoot(x, y)
      sector = @sectors[x][y]
      if sector.state == :ship || sector.state == :hit
        @hit_sectors_size += 1 if sector.state == :ship
        sector.state = :hit
      else
        sector.state = :miss
      end
      sector.state
    end

    def battle_lost?
      @hit_sectors_size == @ship_sectors_size
    end

    def to_s
      to_s = ''
      0.upto(size-1) do |y|
        to_s += "\n"
        0.upto(size-1) do |x|
          to_s += " #{sectors[x][y]}"
        end
      end
      to_s
    end
  end
end
