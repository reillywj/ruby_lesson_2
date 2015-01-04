#Tic Tac Toe

# Playing Tic Tac Toe game.  Two players take turns placing X's and O's on the board.  A player wins when they get three in a row.  It's a tie if all the spaces are taken and neither player has three in a row.
class Board
  attr_accessor :boxes
  
  BOX_LOCATIONS = {'1' => [0,0], '2' => [0,1], '3' => [0,2], '4' => [1,0], '5' => [1,1], '6' => [1,2], '7' => [2,0], '8' => [2,1], '9' => [2,2]}

  def initialize
    @boxes = {'1' => '1', '2' => '2', '3' => '3', '4' => '4', '5' => '5', '6' => '6', '7' => '7', '8' => '8', '9' => '9'}
  end

  def place_marker_on_board(location, marker)
      self.boxes[location] = marker.upcase
  end

  def array_of_marker_locations(marker)
    boxes.select {|locations, box| box == marker.upcase}
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
      print "#{" "*2 + boxes[start.to_s] + " "*2}|#{" "*2 + boxes[(start+1).to_s] + " "*2}|#{" "*2 + boxes[(start+2).to_s] + " "*2}"
    else
      print "#{" "*5}|#{" "*5}|#{" "*5}"
    end
  end

  def divider
    section = "-"*5
    print "#{section}+#{section}+#{section}"
  end

  def tell_invalid(location)
    puts "#{location} is invalid. Try again."
  end
end

class Player
  WINNING_POSITIONS = [['1','2','3'], ['4','5','6'],['7','8','9'],['1','4','7'],['2','5','8'],['3','6','9'],['1','5','9'],['3','5','7']]

  attr_reader :name
  attr_accessor :choice, :marker

  MARKERS = ['x', 'o']

  def is_winner?(board)
    array = []
    marker_locations = (board.array_of_marker_locations marker).keys
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

  def initialize
    puts "Enter your name: "
    @name = gets.chomp
    @marker = ask_user_which_marker
    @choice = ""
  end

  def ask_user_which_marker
    puts "Which piece? X or O or random. Note: X goes first."
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
  def initialize(marker)
    @name = "The Computer"
    @marker = marker
    @choice = ""
  end

  def randomly_place_piece(array_of_possible_locations)
    array_of_possible_locations.sample
  end

  def find_best_position_available(board, player)
    temporary_board = Board.new
    temporary_board.boxes = board.boxes.select {true}
    available_positions = board.available_boxes
    computer_winning_moves = []
    computer_blocking_moves = []

    #Check to see if one of the positions is available for the computer to win the game
    available_positions.each do |location|
      temporary_board = Board.new
      temporary_board.boxes = board.boxes.select {true}
      temporary_board.place_marker_on_board(location, marker)
      computer_winning_moves << location if is_winner?(temporary_board)
    end

    #Check to see if the computer must block their opponents next best move
    available_positions.each do |location|
      temporary_board = Board.new
      temporary_board.boxes = board.boxes.select {true}
      temporary_board.place_marker_on_board(location, player.marker)
      computer_winning_moves << location if player.is_winner?(temporary_board)
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

  WINNING_POSITIONS = [['1','2','3'], ['4','5','6'],['7','8','9'],['1','4','7'],['2','5','8'],['3','6','9'],['1','5','9'],['3','5','7']]

  attr_accessor :winner, :no_positions, :play_again

  def initialize
    @winner = false
    @no_positions = false
    @play_again = false
  end

  def play
    system "clear"
    say_title "Tic Tac Toe"
    human = Human.new
    computer_marker = "x" if human.marker.downcase == "o"
    computer_marker = "o" if human.marker.downcase == "x"
    computer = Computer.new(computer_marker)
    puts human.to_s
    puts computer.to_s

    ttt_board = Board.new
    begin
      human.marker = human.ask_user_which_marker if play_again
      if play_again
        computer.marker = "x" if human.marker == "o"
        computer.marker = "o" if human.marker == "x"
      end
      begin
        system "clear"
        computer_place_best_piece(ttt_board, computer, human) if computer.marker == "x"
        say_title "#{human.name}, It's Your Turn"
        ttt_board.show_board
        player_location = ""
        self.no_positions = check_if_positions ttt_board
        until no_positions || ttt_board.available_boxes.include?(player_location)
          player_location = ask_user "Where would you like to place your #{human.marker.upcase}?"
        end
        ttt_board.place_marker_on_board(player_location, human.marker) unless no_positions

        self.no_positions = check_if_positions ttt_board
        computer_place_best_piece(ttt_board, computer, human) if computer.marker == "o" && !no_positions && !(human.is_winner? ttt_board)

        self.no_positions = check_if_positions ttt_board
        self.winner = check_if_winner(ttt_board, human, computer)
      end until no_positions || winner
      system "clear"
      say_title "GAME OVER"
      puts human.to_s
      puts human.is_winner? ttt_board
      puts computer.to_s
      puts computer.is_winner? ttt_board

      declare_results(ttt_board, human, computer)

      say_title "Play again?"
      answer = ""

      answer = ask_user "Would you like to play again? y or n: " until ['y','n'].include? answer
      self.play_again = answer == 'y'
      ttt_board = Board.new
    end while play_again
    say_title "Game is Terminating"
    say "#{human.name}, Thank you for playing Tic Tac Toe!"
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