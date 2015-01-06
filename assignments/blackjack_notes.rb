# Object Oriented Blackjack game

# 1) Abstraction
# 2) Encapsulation: encapsulate certain behaviors
# Instance variables holds the state of an object


#is a relationship: leads to Inheritance
#E.g. Animal, a Dog is an Animal

#has a relationship: leads to mixins
#Dog has swimmable and runable behaviors
#A Fish only has swimmable behaviors

# Data oriented approach
# Separating them out into objects
# Then you build an engine on how the objects interact with each other

class Card
  attr_reader :suit, :face_value

  def initialize(s, fv)
    @suit, @face_value = s, fv
  end

  def to_s
    "#{face_value} of #{find_suit}"
  end

  def find_suit
    case suit
      when 'H' then 'Hearts'
      when 'D' then 'Diamonds'
      when 'S' then 'Spades'
      when 'C' then 'Clubs'
    end
  end
end

class Deck
  SUITS = ['H', 'S', 'D', 'C'].freeze
  FACE_VALUES = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].freeze
  
  attr_accessor :cards
  attr_reader :number_of_standard_decks, :min_size

  def initialize(number = 1)
    @number_of_standard_decks = number
    @min_size = @number_of_standard_decks * 20
    #set cards in deck
    reset_deck
  end

  def deal_one
    cards.pop #return Card obj
  end

  def shuffle_cards!
    cards.shuffle!
  end

  def reset_deck
    @cards = []
    (1..number_of_standard_decks).each do
      SUITS.each do |suit|
        FACE_VALUES.each do |face_value|
          @cards << Card.new(suit, face_value)
        end#face_values
      end#suits
    end#number_decks
    shuffle_cards!
  end

  def size
    cards.size
  end

  def too_small?
    size < min_size
  end
end

module Hand
  BLACKJACK = 21.freeze

  def show_hand
    say_title "#{name}'s Hand"
    cards.each do |card|
      say card.to_s
    end
    say "#{name}'s hand is worth #{total}."
  end

  def show_top_card
    say_title "#{name}'s Hand"
    say "First card is hidden."
    say cards.last.to_s
  end

  def total
    number_of_aces = 0
    total = 0
    #Count aces (if aces), add total of non-aces
    @cards.each do |card|
      if card.face_value == 'A'
        number_of_aces += 1
      elsif ['J','Q','K'].include? card.face_value
        total += 10
      elsif
        total += card.face_value.to_i
      end#if
    end#do
    #Add in Aces values
    if number_of_aces > 0
      for i in (1..number_of_aces) do
        if total + (11 * (number_of_aces - i + 1)) > BLACKJACK
          total += 1
        else
          total += 11
        end#if
      end#do
    end#if
    total
  end#def

  def blackjack?
    total == BLACKJACK
  end

  def busted?
    total > BLACKJACK
  end

  def add_card(new_card)
    @cards << new_card
  end

  def reset_cards
    @cards = []
  end

  def say_title(message)
    say "#{"-"*15}#{message}#{"-"*15}"
  end

  def say(message)
    puts "#{message}"
  end
end

class Player
  include Hand

  attr_accessor :cards, :name

  def initialize(n)
    @name = n
    @cards = []
  end
end

class Dealer
  include Hand

  attr_accessor :cards
  attr_reader :name

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def stay?
    total >= 17
  end

end

class Blackjack
  attr_accessor :player, :deck, :dealer, :play_again

  def initialize(number_of_standard_decks = 1)
    @deck = Deck.new(number_of_standard_decks)
    @player = Player.new("Player1")
    @dealer = Dealer.new
    @play_again = true
  end

  def start
    welcome_message
    set_player_name
    while play_again
      deal_cards
      show_flop
      player_turn
      dealer_turn
      who_won?(player, dealer)
      ask_to_play_again
      reset_cards if play_again
      reset_deck if play_again && deck.too_small?
    end

    game_over
  end

  private

  def welcome_message
    system 'clear'
    say_title "Welcome to Blackjack!"
  end

  def set_player_name
    puts "#{player.name}, what's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    system 'clear'
    say_title "Cards Dealt"
    player.add_card deck.deal_one
    dealer.add_card deck.deal_one
    player.add_card deck.deal_one
    dealer.add_card deck.deal_one
  end

  def show_hands
    player.show_hand
    dealer.show_hand
  end

  def show_flop
    player.show_hand
    dealer.show_top_card
  end

  def player_turn
    say_title "#{player.name}'s Turn"
    say_deck_size
    ask_to_hit
  end

  def ask_to_hit
    stay = false
    until player.busted? || stay || player.blackjack?
      player.show_hand
      say_title "Hit or Stay?"
      say "y: Hit or n: Stay"
      answer = gets.chomp.downcase
      if ['y','n'].include? answer
        stay = answer == 'n'
        player.add_card deck.deal_one unless stay
      else
        say "#{answer} is invalid. Enter y or n."
        ask_to_hit
      end
    end
  end

  def dealer_turn
    until player.busted? || dealer.stay? || player.blackjack?
      dealer.add_card deck.deal_one
    end
  end

  def who_won?(player, dealer)
    system 'clear'
    say_title "Hand Over"
    player.show_hand
    dealer.show_hand
    say_title "Result:"
    if player.busted?
      say "You busted with #{player.total}."
    elsif dealer.busted?
      say "The #{dealer.name} busted with #{dealer.total}."
    elsif player.blackjack?
      say "BLACKJACK! You win!"
    elsif dealer.blackjack?
      say "The #{dealer.name} hit BLACKJACK. You lose."
    elsif player.total == dealer.total
      say "It's a tie!"
    elsif player.total > dealer.total
      say "You beat #{dealer.name} #{player.total} to #{dealer.total}."
    else
      say "You lost to the #{dealer.name} #{dealer.total} to #{player.total}."
    end#if
  end

  def say_deck_size
    say "The deck has #{deck.size} cards. It will reshuffle at the end of the turn when there's fewer than #{deck.min_size} cards."
  end

  def ask_to_play_again
    say_title "Play Again?"
    say "Do you want to play another hand? y or n: "
    say_deck_size
    answer = gets.chomp.downcase
    if ['y','n'].include? answer
      self.play_again = answer == 'y'
    else
      say "#{answer} was invalid. y or n."
      ask_to_play_again
    end
  end

  def say_title(message)
    say "#{"-"*15}#{message}#{"-"*15}"
  end

  def reset_cards
    player.reset_cards
    dealer.reset_cards
  end

  def reset_deck
    deck.reset_deck
    puts "Deck is being reset!"
    sleep 3.0
  end

  def game_over
    system 'clear'
    say_title "GAME OVER"
    say "#{player.name}, thank you for playing Blackjack!"
  end

  def say(message)
    puts message
  end
end

game = Blackjack.new 2
game.start







