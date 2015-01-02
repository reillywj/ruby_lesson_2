#Module practice.
module Towable
  def can_tow?(weight)
    weight < 10000
  end
end

#Vehicle class to practice inheritance to MyCar and MyTruck
class Vehicle
  attr_accessor :color, :speed
  attr_reader :year, :model

  @@number_of_vehicles = 0
  
  def initialize(color = black, year = 2015, model)
    @color = color
    @year = year
    @model = model
    @speed = 0

    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles."
    @@number_of_vehicles
  end

  def self.gas_mileage(gallons, miles)
    puts "Your gas mileage is #{miles/gallons} mpg."
  end

  def brake(number)
    slow_down_by = number if number < self.speed
    slow_down_by = self.speed if number >= self.speed
    self.speed -= slow_down_by
    puts "You applied the brakes and slowed down by #{slow_down_by} mph." 
  end

  def speed_up(number)
    self.speed += number
    puts "You sped up by #{number} mph."
  end

  def current_speed
    puts "Your current speed is #{self.speed} mph."
  end

  def shut_car_off
    puts "This #{self.model} is driving too fast and brakes will be applied to turn off the car." if self.speed > 0
    self.brake(self.speed) if self.speed > 0
    puts "Car turned off."
  end

  def spray_paint(color_change)
    self.color = color_change
  end

  def to_s
    "You're driving a #{self.year}, #{color} #{self.model}."
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end


#MyCar class which is a child of Vehicle
class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
  @@number_of_cars = 0

  def initialize(year = 2015, color = "black", model = "Ford")
    super(color, year, model)
    @@number_of_cars += 1
  end

  def self.number_of_cars
    puts "There are #{@@number_of_cars} cars."
    @@number_of_cars
  end
end

#MyTruck which is also a child of Vehicle
class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2
  @@number_of_trucks = 0

  def initialize(year = 2015, color = "black", model = "Ford")
    super(color, year, model)

    @@number_of_trucks += 1
  end

  def self.number_of_trucks
    puts "There are #{@@number_of_trucks} trucks."
    @@number_of_trucks
  end
end


#Useful Methods to test the inheritance exercises
def say(message)
  puts "#{"-"*10}#{message}#{"-"*10}"
end

def tell_vehicle_summary
  say "Vehicle Summary"
  Vehicle.number_of_vehicles
  MyCar.number_of_cars
  MyTruck.number_of_trucks
  say "-"*14
end

say "Number of Vehicles"
tell_vehicle_summary
say "Create a Honda Accord"
accord = MyCar.new(2010, "red", "Honda Accord")
puts accord
tell_vehicle_summary
say "Create a Ford F-150"
f150 = MyTruck.new(1960, "blue", "Ford F-150")
puts f150
tell_vehicle_summary

say "Exercise 4: Print to Screen Ancestors"
say "Vehicle"
puts Vehicle.ancestors
say "MyCar"
puts MyCar.ancestors
say "MyTruck"
puts MyTruck.ancestors

say "Accord's Age is:"
puts accord.age

say "F-150 Age is:"
puts f150.age





