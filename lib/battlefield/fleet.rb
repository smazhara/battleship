module Battlefield
  class Fleet
    attr_reader :ships

    def initialize(structure)
      @ships = {}
      structure.each do |size, count|
        @ships[size] = (1..count).map{|i| Ship.new(i)}
      end
    end

    def ships_size
      ships.inject(0) {|total,s| total + s.last.size}
    end
  end
end
