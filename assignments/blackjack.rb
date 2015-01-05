# blackjack.rb
# Assignment: OO Blackjack - Extract Nouns and Verbs
# Write out the requirements of the blackjack game, and extract the major nounts.  Use those nouns to then think about abstracting behaviors into Classes. Use a pen or text editor for this exercise; no coding yet.
# 
# Player bets an amount from their bank. Dealer deals two cards, alternating to the player(s) and themselves. The player determines whether they want to hit or stay. Assuming the player does not bust or hits 21 (blackjack), the dealer then deals cards until their total value of their cards are 17 or greater.  Player wins if they don't bust and total value is greater than the dealer or if the dealer busts, and the player wins their bet x2; if the player and the dealer tie, it's a draw and the player earns their bet back; else, the dealer wins the players money.
# 
# Nouns/Verbs:
#   -GeneralPlayer
#     -Has a hand
#     -Calculates total value of hand
#     -Has a name
#     -Choose to hit or stay
#     -Busts if total value of hand > 21
#   -Player < GeneralPlayer
#     -Bets
#     -Receives Another Card if chooses to Hit
#     -Turn over if chooses to stay or busts
#   -TheHouse < GeneralPlayer
#     -If any player stays, then 'hits' until total is 17 or greater
#   -Deck
#     -Consists of a number of standard deck
#     -Standard deck: 52 cards, 4 suits or 13 cards
#     -Shuffle Deck
#     -Deal card from deck
#   -Card
#     -Has a suit and a face value (e.g. 2 of diamonds or K of spades)
#   -Gameplay
#     -Deal two cards to all players
#     -Ask each Player to hit/stay until stay or bust
#     -Dealer receive

# Now build into classes

require 'pry'
class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def busted?
    calculate_total > 21
  end

  def calculate_total
    number_of_aces = 0
    total = 0
    cards.each do |card|
      if card.value == 'A'
        number_of_aces += 1
      elsif ['J', 'Q', 'K'].include? card.value
        total += 10
      else
        total += card.value.to_i
      end
    end

    if number_of_aces > 0
      for i in 1..number_of_aces do
        if total + (11 * (number_of_aces - i + 1)) > 21
          total += 1
        else
          total += 11
        end
      end
    end
    #return total
    total
  end

  def clear_hand
    self.cards = []
  end

  def to_s
    message = ""
    cards.each{|card| message = message + card.to_s + "\n"}
    message
  end
end

class GeneralPlayer
  attr_accessor :hand, :name, :hit_value

  def initialize(n)
    @hand = Hand.new
    @name = n
    @hit_value = true
  end

  def hit?
    puts "#{name}, would you like to hit: y, or stay: n?"
    answer = gets.chomp.downcase
    if ['y', 'n'].include? answer
      self.hit_value = answer == 'y'
    else
      puts "#{answer} is invalid. Y for hit, N for stay."
      hit?
    end
  end

  def new_hand
    self.hand = Hand.new
  end

  def to_s
    "#{name} is holding #{hand}." if !hand.cards.empty?
    "#{name} is holding nothing." if  hand.cards.empty?
  end
end

class Player < GeneralPlayer
  def initialize(player_number = 1)
    @hand = Hand.new
    puts "Player #{player_number}, what's your name?"
    @name = gets.chomp
    @hit_value = true
  end
end

class TheHouse < GeneralPlayer
  def initialize
    super "The House"
  end

  def hit?
    if hand.calculate_total < 17
      self.hit_value = true
    else
      self.hit_value = false
    end
  end
end

class Deck
  attr_accessor :number_of_decks, :cards
  SUITS  = ['hearts', 'diamonds', 'spades', 'clubs'].freeze
  VALUES = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].freeze

  def initialize(number = 1)
    @number_of_decks = number
    @cards = reset_deck number
  end

  def reset_deck(number)
    deck = []
    for i in 1..number do
      SUITS.each do |suit|
        VALUES.each do |value|
          deck << Card.new(suit, value)
        end
      end
    end
    deck
  end

  def shuffle_deck
    cards.shuffle!
  end

  def deal_card_from_deck
    cards.pop #returns the card that is removed from the deck
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit, @value = s, v
  end

  def to_s
    "#{value} of #{suit.capitalize}"
  end
end

class Blackjack
  attr_accessor :deck
  def play
    system 'clear'
    deck      = Deck.new 1
    player1   = Player.new
    the_house = TheHouse.new

    deck.shuffle_deck

    #Deal cards
    player1.hand.add_card deck.deal_card_from_deck
    show_all_cards player1
    the_house.hand.add_card deck.deal_card_from_deck
    deal_delay
    player1.hand.add_card deck.deal_card_from_deck
    show_all_cards player1
    the_house.hand.add_card deck.deal_card_from_deck
    deal_delay
    show_top_card the_house
    show_all_cards player1

    #Ask Player to hit or stay?
    while player1.hit_value && !player1.hand.busted?
      player1.hit?
      player1.hand.add_card deck.deal_card_from_deck if player1.hit_value
      show_all_cards player1
    end

    show_all_cards the_house
    #Computer hits or stays
    unless player1.hand.busted? && the_house.hit_value
      the_house.hit?
      the_house.hand.add_card deck.deal_card_from_deck if the_house.hit_value
      show_all_cards the_house
    end

    #
  end

  def ask_player_to_hit_or_stay(player)
    puts "#{player.name}, would you like to hit (y) or stay (n)?"
    response = gets.chomp.downcase
    if ['y','n'].include? response
      response == 'y'
    else
      puts "#{response} is invalid. Y for hit. N for stay."
      ask_player_to_hit_or_stay player
    end
  end

  def deal_delay
    sleep 0
  end

  def show_top_card(player)
    puts "#{player.name} shows: #{player.hand.cards[0]} and #{Card.new("Unknown", "Unknown")}."
    puts ""
  end

  def show_all_cards(player)
    puts "#{player.name}: \n#{player.hand}"
    puts "#{player.name}'s hand is valued at #{player.hand.calculate_total}."
    puts ""
  end
end

Blackjack.new.play













