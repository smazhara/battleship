# -*- coding: undecided -*-
require 'ship'
require 'fleet'
require 'battlefield'
require 'sector'

describe Ship do
  it "should have size" do
    Ship.new(1).size.should == 1
  end

  it "should not have size = 0" do
    lambda do
      Ship.new(0)
    end.should raise_error(ArgumentError)
  end

  it "should not allow negative sizes" do
    lambda do
      Ship.new(-1)
    end.should raise_error(ArgumentError)
  end

end

describe Fleet do
  it "should be able to provision itself" do
    fleet = Fleet.new 5=>1, 4=>2
    fleet.ships_size.should == 3
  end
end

describe Battlefield do
  it "should have size" do
    fleet = Fleet.new({})
    Battlefield.new(10, fleet).size.should == 10
  end

  it "should deploy carrier" do
    fleet = Fleet.new 5=>1
    bf = Battlefield.new(10, fleet)
    bf.deploy(Ship.new(5), [1,1], :horizontal)
    bf.occupied_sectors.should_not be_empty

    # overlap
    lambda do
      bf.deploy(Ship.new(5), [1,1], :horizontal)
    end.should raise_error(ArgumentError)

    # boundary
    lambda do
      bf.deploy(Ship.new(1), [20,20], :vertical)
    end.should raise_error(ArgumentError)

    # todo - fleet rules
  end

  it "should tell whether it's a miss or hit" do
    fleet = Fleet.new 5=>1
    bf = Battlefield.new(10, fleet)
    bf.deploy(Ship.new(5), [1,1], :horizontal)

    bf.shoot(5,5).should == :miss
    bf.shoot(1,1).should == :hit
  end

  it "should tell whether battle is lost" do
    fleet = Fleet.new 5=>1
    bf = Battlefield.new(10, fleet)
    bf.deploy(Ship.new(5), [1,1], :horizontal)

    bf.battle_lost?.should == false

    1.upto(2) do |x|
      bf.shoot(x,1).should == :hit
    end
    bf.battle_lost?.should == false

    1.upto(5) do |x|
      bf.shoot(x,1).should == :hit
    end
    bf.battle_lost?.should == true
  end

  it "should not fail if ships do not overlap" do
    fleet = Fleet.new 2=>2
    bf = Battlefield.new 10, fleet
    lambda {
      bf.deploy Ship.new(2), [1,1], :horizontal
      bf.deploy Ship.new(2), [3,3], :horizontal
    }.should_not raise_error(ArgumentError)
  end

  it "should show itself" do
    fleet = Fleet.new 2=>2
    bf = Battlefield.new 10, fleet
    bf.deploy Ship.new(2), [1,1], :horizontal
    puts bf.to_s
  end
end
