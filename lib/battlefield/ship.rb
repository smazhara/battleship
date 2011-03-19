module Battlefield
  class Ship
    attr_reader :size

    def initialize(size)
      raise ArgumentError if size <= 0
      @size = size
    end
  end
end
