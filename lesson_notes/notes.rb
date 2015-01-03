#OOP in Ruby
# 1. classes and objects
# 2. classes contain behaviors
#    -Behaviors correlate to instance methods, like speak; encapsulating behavior we want in a particular class object
#    -States correlate to instance variables.
#    -OOP we want to build these classes with these behaviors and states

class Dog
  attr_accessor :weight, :height, :name
  attr_reader :birth_year

  DOG_YEARS = 7

  @@number_of_dogs = 0
  @@names_of_dogs = []

  def initialize(n, year_born, h, w)
    @name = n
    @birth_year = year_born
    @height = h
    @weight = w

    @@number_of_dogs += 1
    @@names_of_dogs << n
  end

  def self.number_of_dogs
    puts "There are #{@@number_of_dogs} dogs."
    @@number_of_dogs
  end

  def self.names_of_dogs
    @@names_of_dogs
  end

  def speak
    "bark!"
  end

  def info
    "#{@name} is #{height} foot tall and weighs #{weight} pounds and is #{age} years old or #{doggy_years} in doggy years."
  end

  private

  def doggy_years
    DOG_YEARS * age
  end

  def age
    Time.now.year - self.birth_year
  end
end

teddy = Dog.new("Teddy", 2000, 3, 200)
teddy.speak

fido = Dog.new("Fido", 2012, 1, 20)
puts fido.speak
puts fido.info
fido.name = "Auggie"
puts fido.info

Dog.number_of_dogs
p Dog.names_of_dogs






















