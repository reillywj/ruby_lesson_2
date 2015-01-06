#Covering self
class Car
  attr_accessor :name

  NUM_OF_WHEELS = 4

  puts "top level self is: " + self.inspect

  def initialize(n)
    @name = n
  end

  def self.my_class_method
    puts self.inspect
    puts "A class method."
  end

  def an_instance_method
    puts "self is: " + self.inspect
    puts "an instance method"
  end
end

def Car.another_class_method
  puts "Another class method!"
end

# 1) singleton class - shadows an object
    # - can declare methods on the singleton class that is only callable by that one object of that class
# 2) all classes are objects, as well
      # - all classes are of class Class

# Objects use them to orchestrate more complicated programs

# In Ruby, singleton class interjects the Object way of thinking
# Can define methods on individual objects

#within the class but outside any method definition, self is the class
#otherwise self is the class instance

bob = Car.new('bob')
jim = Car.new('jim')

# Car.my_class_method
# Car.another_class_method

#Following lives in the singleton class
def bob.special_method
  puts "this is bob's special method"
end

# bob.special_method
# jim.special_method #=>fails
# Car.special_method #=>fails

#singletons are used especially when building DSLs

#---------------------
#
# What a regular method call from an inherited class
# class User < ActiveRecord::Base
#   has_many :posts
# end

# def has_many(opts)

# end

#---------------------

#All abstractions have a cost
#regarding rails tutorial isn't a one size fit all
#get leaks as you learn on things you actually want to do
#need to understand what's going on underneath the hood of the engine

#---------------------
#
#



puts Car.inspect
puts bob.class
puts Car.class #=> Class - All classes, are objects of class Class

# Car is a constant
# Note: can write constants as either CONSTANTS or Constants


# Can you instantiate a class with type Class?
some_class = Class.new do
  attr_accessor :name
  #etc.
end

#So yes, all classes are objects themselves.
#Can do
def Car.another_class_method
  puts "Another class method!"
end

puts Class.ancestors

# By default methods have self. prepended to them
#so...
class Dog
  attr_accessor :name #attr_accessor is a singleton with self. on front, calling the Dog object and passing in the symbol :name into the method attr_accessor, which builds the getter and setter methods to self
end






