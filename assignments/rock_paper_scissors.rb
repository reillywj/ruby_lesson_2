# OO Rock, Paper, Scissors
# 1. Ask player to choose
# 2. Computer chooses RPS
# 3. Show outcome
# 4. Say who won
# 5. Ask to play again

class Throw
  OPTIONS = ["Rock", "Paper", "Scissors"]
end

module Choices
  CHOICES = {'r' => 'Rock', 'p' => 'Paper', 's'=> 'Scissors'}
end

class Player
  include Choices
  attr_reader :name
  attr_accessor :choice

  def initialize
    print "Enter your name: "
    @name = gets.chomp
    @choice = ''
  end

  def throw_rps
    print "Rock(R), Paper(P), or Scissors(S): "
    response = gets.chomp.downcase
    if CHOICES.keys.include? response
      self.choice = CHOICES[response]
    else
      tell_invalid response
      throw_rps
    end
  end

  def tell_invalid(entry)
    puts "="*5
    puts "#{entry} is an invalid entry."
    puts "="*5
  end
end

class Computer
  include Choices
  attr_accessor :choice
  def initialize
    @choice = ''
  end

  def throw_rps
    self.choice = CHOICES[CHOICES.keys.sample]
  end
end

class RPS
  attr_accessor :keep_playing
  include Choices
  PLAYER_WINS_MATRIX = {["Rock", "Scissors"] => "Rock smashes Scissors.", ["Paper", "Rock"] => "Paper smothers Rock.", ["Scissors", "Paper"]=>"Scissors cuts Paper."}
  def initialize
    @keep_playing = true
  end

  def run
    system "clear"
    player = Player.new
    computer = Computer.new

    puts "Hello #{player.name}. Let's play some Rock, Paper, Scissors!"

    begin
      divider
      player.throw_rps
      computer.throw_rps
      show_choices(player.choice, computer.choice)
      show_winner(player.choice, computer.choice)
      keep_playing?
    end while self.keep_playing

    divider
    puts "Thank you for playing Rock, Paper, Scissors, #{player.name}!!!!1111oneone"
  end

  def divider
    puts "-"*20
  end

  def show_choices(player_choice, computer_choice)
    puts "You chose #{player_choice} and the computer chose #{computer_choice}."
  end

  def show_winner(player_choice, computer_choice)
    choice_matrix = [player_choice, computer_choice]
    if choice_matrix[0] == choice_matrix[1]
      puts "It's a tie!"
    elsif PLAYER_WINS_MATRIX.keys.include? choice_matrix
      puts PLAYER_WINS_MATRIX[choice_matrix] + " You win!"
    else
      puts PLAYER_WINS_MATRIX[choice_matrix.reverse] + " You lose!!!"
    end
  end

  def keep_playing?
    print "Play again? y/n: "
    answer = gets.chomp.downcase
    if ["y", "n"].include? answer
      self.keep_playing = answer == "y"
    else
      keep_playing?
    end
  end

  def tell_choices
    "You picked "
  end
end

RPS.new.run


