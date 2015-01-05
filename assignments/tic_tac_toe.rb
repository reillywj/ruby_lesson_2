#Tic Tac Toe

# Playing Tic Tac Toe game.  Two players take turns placing X's and O's on the board.  A player wins when they get three in a row.  It's a tie if all the spaces are taken and neither player has three in a row.

class Board
  attr_accessor :boxes

  def initialize
    @boxes = {'1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6', '7' => '7', '8' => '8', '9' => '9'}
  end

  def place_marker_on_board(location, marker)
      self.boxes[location] = marker.upcase
  end

  def array_of_marker_locations(marker)
    boxes.select {|locations, box| box == marker.upcase}.keys
  end

  def available_boxes
    boxes.select {|location, box| box =~ /[1-9]/}.keys
  end

  def show_board
    puts line
    puts line 1
    puts line
    puts divider
    puts line
    puts line 4
    puts line
    puts divider
    puts line
    puts line 7
    puts line
  end

  def line(start = 0)
    if start > 0
      print "#{" " * 2 + boxes[start.to_s] + " " * 2}|#{" " * 2 + boxes[(start+1).to_s] + " " * 2}|#{" " * 2 + boxes[(start+2).to_s] + " " * 2}"
    else
      print "#{" " * 5}|#{" " * 5}|#{" " * 5}"
    end
  end

  def divider
    section = "-" * 5
    print "#{section}+#{section}+#{section}"
  end

  def tell_invalid(location)
    puts "#{location} is invalid. Try again."
  end
end

class Player
  attr_reader :name
  attr_accessor :choice, :marker

  WINNING_POSITIONS = [['1','2','3'], ['4','5','6'],['7','8','9'],['1','4','7'],['2','5','8'],['3','6','9'],['1','5','9'],['3','5','7']]
  MARKERS = ['x', 'o']

  def is_winner?(board)
    array             = []
    marker_locations  = (board.array_of_marker_locations marker)
    WINNING_POSITIONS.each_index {|index| array[index] = (WINNING_POSITIONS[index] & marker_locations).count == 3}
    array.include? true
  end

  def to_s
    "#{name}: #{marker.upcase}'s"
  end

  def self.markers
    MARKERS
  end
end

class Human < Player

  def initialize(player_number)
    puts "#{player_number}, enter your name: "
    @name   = gets.chomp
    @marker = "x"
    @choice = ""
  end

  def ask_user_which_marker
    puts "#{name}, which piece would you like to be? X or O or random. Note: X goes first."
    answer = "x"
    begin
      tell_invalid(answer) unless MARKERS.include? answer
      answer = gets.chomp.downcase
      answer = MARKERS.sample if answer == "random"
    end until MARKERS.include? answer
    answer
  end

  def tell_invalid(marker)
    puts "#{marker} is an invalid entry. Do you want to be X's or O's?"
  end
end

class Computer < Player
  def initialize
    @name   = "The Computer"
    @marker = 'o'
    @choice = ""
  end

  def randomly_place_piece(array_of_possible_locations)
    array_of_possible_locations.sample
  end

  def find_best_position_available(board, player)
    temporary_board         = Board.new
    temporary_board.boxes   = board.boxes.select {true}
    available_positions     = board.available_boxes
    computer_winning_moves  = []
    computer_blocking_moves = []

    #Check to see if one of the positions is available for the computer to win the game
    available_positions.each do |location|
      temporary_board       = Board.new
      temporary_board.boxes = board.boxes.select {true}
      temporary_board.place_marker_on_board(location, marker)
      computer_winning_moves << location if is_winner?(temporary_board)
    end

    #Check to see if the computer must block their opponents next best move
    available_positions.each do |location|
      temporary_board       = Board.new
      temporary_board.boxes = board.boxes.select {true}
      temporary_board.place_marker_on_board(location, player.marker)
      computer_blocking_moves << location if player.is_winner?(temporary_board)
    end
    best_position = []
    best_position = (computer_winning_moves.shuffle << computer_blocking_moves.shuffle).flatten
    best_position = available_positions.shuffle if best_position.empty?
    best_position
  end

  def play_best_position(board, player)
    find_best_position_available(board, player)[0]
  end
end

class TTT
  attr_accessor :winner, :no_positions, :play_again, :current_player

  def initialize
    @winner         = false
    @no_positions   = false
    @play_again     = false
    @current_player = ""
  end

  def play
    system "clear"
    say_title "Tic Tac Toe"
    number_of_players = ask_number_of_players
    player1           = Human.new("Player 1")
    player2           = Computer.new          if number_of_players == 1
    player2           = Human.new("Player 2") if number_of_players == 2
    ttt_board         = Board.new
    begin
      player1.marker  = player1.ask_user_which_marker

      set_computer_marker_and_current_player(player1, player2)

      begin
        system "clear"
        
        if    current_player.class.to_s == "Computer"
          computer_place_best_piece(ttt_board, player2, player1)
          ttt_board.show_board
        elsif current_player.class.to_s == "Human"
          say_title "#{current_player.name}, It's Your Turn"
          ttt_board.show_board

          #Player chooses location if choice is available, then place on board.
          player_choice   = ""
          self.no_positions = check_if_positions ttt_board
          until no_positions || ttt_board.available_boxes.include?(player_choice)
            player_choice = ask_user "Where would you like to place your #{current_player.marker.upcase}?"
          end
          ttt_board.place_marker_on_board(player_choice, current_player.marker)
        end

        #Alternate turns
        alternate_current_player(player1, player2)

        self.no_positions = check_if_positions ttt_board
        self.winner       = check_if_winner(ttt_board, player1, player2)
      end until no_positions || winner
      system "clear"
      say_title "GAME OVER"
      puts player1.to_s
      puts player2.to_s

      declare_results(ttt_board, player1, player2)

      say_title "Play again?"
      answer          = ""
      answer          = ask_user "Would you like to play again? y or n: " until ['y','n'].include? answer
      self.play_again = answer == 'y'
      ttt_board = Board.new
    end while play_again

    good_bye_sequence(player1, player2)
  end

  def ask_number_of_players
    number_of_players = 1
    say_title "Number of Players"
    say "How many players? 1 or 2: "
    response = gets.chomp
    if response.to_i.to_s == response
      number_of_players = response.to_i
    else
      say "#{response} was invalid. Looking for 1 or 2 players: "
      ask_number_of_players
    end
    number_of_players
  end

  def good_bye_sequence(player1, player2)
    system 'clear'
    say_title "Game is Terminating"
    say "#{player1.name}, Thank you for playing #{player2.name} in Tic Tac Toe!"
    sleep 1.0
    say "Screen will clear automatically in 2 seconds."
    sleep 2.0
    say "Have a nice day!"
    sleep 1.0
    system 'clear'
  end

  def alternate_current_player(player1, player2)
    if current_player == player1
      self.current_player = player2
    else
      self.current_player = player1
    end
  end

  def set_computer_marker_and_current_player(player1, player2)
    if player1.marker.downcase == "o"
      player2.marker = "x"
      self.current_player = player2
    else
      player2.marker = "o"
      self.current_player = player1
    end
  end

  def check_if_winner(board, player1, player2)
    player1.is_winner?(board) || player2.is_winner?(board)
  end

  def declare_results(board, player1, player2)
    board.show_board
    if player1.is_winner? board
      say_winner(player1, player2)
    elsif player2.is_winner? board
      say_winner(player2, player1)
    else
      say "It's a tie!"
    end
  end

  def say_winner(winner, loser)
    say_title "#{winner.name} defeated #{loser.name}!"
  end

  def check_if_positions(board)
    board.available_boxes.empty?
  end

  def computer_randomly_place_piece(board, computer)
    board.place_marker_on_board(computer.randomly_place_piece(board.available_boxes), computer.marker)
  end

  def computer_place_best_piece(board, computer, opponent)
    board.place_marker_on_board(computer.play_best_position(board, opponent), computer.marker)
  end

  def divider
    say_title("-"*10)
  end

  def say_title(message)
    puts "#{"-"*10}#{message}#{"-"*10}"
  end

  def say(message)
    puts "#{message}"
  end

  def ask_user(question)
    say "#{question}"
    answer = gets.chomp.downcase
    answer
  end
end

TTT.new.play