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
#  Note: Moved hand from GeneralPlayer into its own class and is then pulled into a GeneralPlayer

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
    @hand       = Hand.new
    @name       = n
    @hit_value  = true
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
  attr_accessor :bank, :current_bet, :play_again
  
  MINIMUM_BET = 50
  
  def initialize(player_number = 1)
    @hand         = Hand.new
    puts          "Player #{player_number}, what's your name?"
    @name         = gets.chomp
    @hit_value    = true
    @bank         = 1000
    @current_bet  = 0
    @play_again   = true
  end
  
  def bet
    puts "You have #{bank} in your bank."
    puts "How much would you like to bet?"
    amount = gets.chomp.to_i
    if amount > bank
      puts "Your #{amount} bet is more than you have in your bank."
      puts "You bet what's in your bank."
      self.current_bet = bank
    elsif amount < MINIMUM_BET && bank >= MINIMUM_BET
      puts "You have at least #{bank} to bet."
      puts "You must bet the minimum bet: #{MINIMUM_BET}."
      bet
    else
      puts "You bet #{amount}."
      self.current_bet = amount
    end
  end
  
  def bankrupt?
    bank == 0
  end
  
  def won_hand
    puts "You won: #{current_bet}"
    self.bank += current_bet
    puts "#{name}'s bank: #{bank}"
    self.current_bet = 0
  end
  
  def lost_hand
    puts "You lost: #{current_bet}"
    self.bank -= current_bet
    puts "#{name}'s bank: #{bank}"
    self.current_bet = 0
  end
  
  def tied_hand
    puts "You tied and neither won nor lost: #{current_bet}"
    puts "#{name}'s bank: #{bank}"
    self.current_bet = 0
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
    (1..number).each do
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
    say_title "Welcome to Blackjack"
    
    player1   = Player.new
    the_house = TheHouse.new
    
    while player1.play_again
      system 'clear'
      say_title "Hello, #{player1.name}. Let's Play"
      deck      = Deck.new 2
      deck.shuffle_deck
      reset_hand(player1, the_house)
      #Ask player to bet
      player1.bet
      
      #Deal cards
      player1.hand.add_card deck.deal_card_from_deck
      show_all_cards player1
      the_house.hand.add_card deck.deal_card_from_deck
      show_no_card the_house
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
        say_title "#{player1.name}, Your Turn"
        player1.hand.add_card deck.deal_card_from_deck if player1.hit_value
        show_all_cards player1
        show_top_card the_house
      end
  
      show_all_cards the_house
      #Computer hits or stays
      while !player1.hand.busted? && the_house.hit_value
        the_house.hit?
        the_house.hand.add_card deck.deal_card_from_deck if the_house.hit_value
        show_all_cards the_house
      end
  
      #Declare winner
      say_title "Hand Over"
      show_winner(player1, the_house)
      
      #Ask to play again
      say_title "Play Again?"
      ask_player_to_play_again(player1)
    end
    
    say_title "GAME OVER"
    puts "You left the table with #{player1.bank} in your pocket."
    puts "Thank you for playing Blackjack!"
  end
  
  def say_title(message)
    puts "#{"-"*15}#{message}#{"-"*15}"
  end
  
  def say_goodbye(player)
    system 'clear'
    puts "#{player.name}, sorry to see you go, thank you for playing Blackjack!"
  end
  
  def reset_hand(player, the_house)
    player.hand         = Hand.new
    player.hit_value    = true
    the_house.hand      = Hand.new
    the_house.hit_value = true
  end
  
  def ask_player_to_play_again(player)
    if player.bankrupt?
      puts "You are bankrupt with #{player.bank} dollars."
      puts "Would you like to keep playing and add 1000 to your bank? y or n"
      answer = gets.chomp.downcase
      if ['y','n'].include? answer
        player.bank = 1000 if answer == 'y'
        player.hand = [] 
        player.play_again = answer == 'y'
      else
        puts "#{answer} is an invalid entry. y or n."
        ask_player_to_play_again(player)
      end
    else
      puts "You have #{player.bank} dollars."
      puts "Do you wish to keep playing? y or n"
      answer = gets.chomp.downcase
      if ['y','n'].include? answer
        player.play_again = answer == 'y'
      else
        puts "#{answer} is invalid. y or n."
        ask_player_to_play_again(player)
      end
    end
      
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
    sleep 1
  end

  def show_top_card(player)
    puts "#{player.name} shows: #{player.hand.cards[0]} and #{Card.new("Unknown", "Unknown")}."
    puts ""
  end
  
  def show_no_card(player)
    puts "#{player.name} shows: #{Card.new("Unknown","Unknown")}."
    puts ""
  end

  def show_all_cards(player)
    puts "#{player.name}: \n#{player.hand}"
    puts "#{player.name}'s hand is valued at #{player.hand.calculate_total}."
    puts ""
  end
  
  def show_winner(player, the_house)
    if player.hand.busted?
      puts "#{player.name} busted with #{player.hand.calculate_total}."
      player.lost_hand
    elsif the_house.hand.busted?
      puts "#{the_house.name} busted with #{the_house.hand.calculate_total}."
      player.won_hand
    elsif player.hand.calculate_total == the_house.hand.calculate_total
      show_current_score(player, the_house)
      player.tied_hand
    elsif player.hand.calculate_total > the_house.hand.calculate_total
      show_current_score(player, the_house)
      player.won_hand
    elsif player.hand.calculate_total < the_house.hand.calculate_total
      show_current_score(player, the_house)
      player.lost_hand
    end
  end
  
  def show_current_score(player, the_house)
    puts "#{player.name} has #{player.hand.calculate_total} and #{the_house.name} has #{the_house.hand.calculate_total}."
  end
end

Blackjack.new.play










































