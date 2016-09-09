class MyVehicle

  @@number_of_vehicles = 0

  attr_accessor :color
  attr_reader :year


  def number_of_vehicles
    puts "There are #{@@number_of_vehicles} in total"
  end

  def self.mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(faster)
    @current_speed += faster
    puts "You push the gas and accelerate #{faster} mph"
  end

  def brake(slower)
    @current_speed -= slower
    puts "You push the brake and deccelerate #{slower} mph"
  end

  def current_speed
    puts "You are travelling at #{@current_speed}mph."
  end

  def shut_down
    @current_speed = 0
    puts "Let's park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
  end


end

class MyTruck < MyVehicle

  WEIGHT_LIMIT = '10 Tonnes'

  end



class MyCar < MyVehicle

  NUMBER_OF_DOORS = 4

  
  def to_s
    "My car is a #{color} #{@model} from #{year}"
  end
end

module Loadable
  def load
    puts "The truck is being loaded"
  end
end

lumina = MyCar.new(1997, 'white', 'chevy lumina')
puts lumina.current_speed

lumina.speed_up(20)
lumina.current_speed
