# 1. Have detailed requirements or specifications in written form.
# 2. Extract major nouns, map to classes
# 3. Extract major verbs, map to instance methods
# 4. Group instance methods into classes

# Major nouns: dealer, card, deck, player
# Verbs: deal, hit, stay, 
# Need to consider where the action occurs
# Such as deal: the dealer will ask the Deck to deal a card to the Player/Dealer as needed

#Multi-line editing: hold down Option key and click/drag cursor

class Card
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit, @value = s, v
  end

  def to_s
    "Card: #{value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards
  attr_reader :

  SUITS = ['hearts', 'diamonds', 'spades', 'clubs']
  CARD_VALUES = ['2','3','4', '5', '6', '7', '8', '9', '10', 'J', 'Q','K', 'A']
  def initialize
    @cards = []
    SUITS.each do |suit|
      CARD_VALUES.each {|face_value| @cards << Card.new(suit, face_value)}
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end

class Player
end

class Dealer
end

#
class Blackjack
  attr_accessor :player, :dealer, :deck
  def initialize
    @player = Player.new("Bob")
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def run
    #Where procedural part of the game starts
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

Blackjack.new.run








