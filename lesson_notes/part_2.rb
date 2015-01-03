#Swimmable expects a name method to be available.
module Swimmable
  def swim
    "#{name} is swimming."
  end

  def drown
    "#{name} can't swim, #{name} is drowning!!!"
  end
end

#Fetchable expects a name method to be available.
module Fetchable
  def fetch
    "#{name} is fetching"
  end
end


class Animal
  attr_accessor :name

  def initialize(n)
    @name = n
  end

  def eat
    "#{name} is eating"
  end

  def speak
    "#{name} is speaking"
  end
end

class Mammal < Animal
  def warm_blooded?
    true
  end
end

class Dog < Mammal
  include Swimmable, Fetchable

  def speak
    "#{name} is barking"
  end
end

class Cat < Animal
  include Swimmable

  def speak #method override over the Animal method of speak
    "#{name} is meowing"
  end
end

#I added something here

teddy = Dog.new('teddy')
puts teddy.name
puts teddy.eat
puts teddy.fetch
puts teddy.speak
puts teddy.warm_blooded?
puts teddy.swim

kitty = Cat.new('kitty')
puts kitty.name
puts kitty.eat
puts kitty.speak
puts kitty.drown

puts Dog.ancestors
puts Cat.ancestors