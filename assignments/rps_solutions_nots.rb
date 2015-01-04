#Comparable module
#Have to write a method <=> and then anOther object of the same class
#Say how to compare the two
#It overrides comparable symbols <, ==, and > comparables of the same class

#Note: there's many right ways but decisive wrong ways to code this.

#Some code somewhere in the middle
# class Hand
#   include Comparable

#   attr_reader :value

#   def initialze(v)
#     @value = v
#   end

#   def <=>(another_hand)
#     #To use Comparabler module <=> must return 1, 0, or -1
#     if @value == another_hand.value
#       0
#     elsif (@value == 'p' && another_hand.value == 'r') || (@value == 'r' && another_hand.value == 's') || (@value == 's' && another_hand.value == 'p')
#       1
#     else
#       -1
#     end 
#   end
# end

# class Player
#   include Comparable

#   attr_accessor :hand
#   attr_reader :name

#   def initialize(n)
#     @name = n
#   end

#   def to_s
#     "#{name} currently has chosen #{choice}."
#   end

#   def pick_hand
#     begin
#       puts "Pick one: (p, r, s):"
#       c = gets.chomp.downcase
#     end until Game::CHOICES.keys.include? c

#     self.choice = c
#   end
# end

# class Human < Player
# end

# class Computer < Player
# end











