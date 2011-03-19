module Battlefield
  class Sector < Struct.new :x, :y, :state
    def self.empty
      new :empty
    end
    def self.ship
      new :ship
    end
    def to_s
      if state == :empty
        '.'
      elsif state == :ship
        '#'
      elsif state == :hit
        '*'
      else state == :miss
        'o'
      end
    end
  end
end
