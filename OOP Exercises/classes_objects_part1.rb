class MyCar
  attr_accessor :color, :speed
  attr_reader :year, :model

  def initialize(year = 2015, color = "black", model = "Ford")
    @year = year
    @color = color
    @model = model
    @speed = 0
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
end

def say(something)
  num = 10
  puts "#{"-"*num}#{something}#{"-"*num}"
end

system "clear"
accord = MyCar.new(2010, "red","Honda Accord")
say "Get Model"
puts accord.model
say "Get Year"
puts accord.year
say "Speed up by 10"
accord.speed_up 10
say "Current Speed"
accord.current_speed
say "Brake by 5"
accord.brake 5
say "Current Speed"
accord.current_speed
say "Turn car off"
accord.shut_car_off
say "Get Car Color before Paint Job"
puts accord.color
say "Get Paint Job and then get Color of Car"
accord.spray_paint("white")
puts accord.color
say "Speed up by 20; Then speed up by 10"
accord.speed_up 20
accord.speed_up 10
say "Current Speed"
accord.current_speed
say "Brake by 30"
accord.brake 30
say "Turn Car off"
accord.shut_car_off















