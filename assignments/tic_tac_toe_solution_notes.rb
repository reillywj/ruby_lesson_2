#To move/rename a file use mv command
#mv <current_file_name.ext> <new_file_name.ext>

#Use _ in the |_, value_use| when it's not used since _ is a valid variable name.

# Two approaches to OOP
# 1. Look at procedural APP and look where you're passing around a lot of objects
#   -Sign that you need a more complicated data structure and extract to a class
#   -Extract classes and objects from existing code
#   -Good if you have a lot of experience and can recognize certain patterns in your code
#
# 2. Write out a description of the program.  Then extract nouns from the description.  And group common verbs into the nouns.
#   -This is a more systematic way of doing OOP.
#
#
# OOP is difficult because everyone has a different mental model on how things are setup and work.

# Do by way of number 2
# Note: This is how I started my TicTacToe OOP code.

# What is a Tic Tac Toe game?

# Two players start with an empty 3x3 board.  The first player places the 'X' in an empty square.  The second player places the 'O' in an empty square. Loop until one of the players gets three in a row or there are no more empty boxes.

# Nouns: board, player, square
# board
#   -squares
#   -all squares marked?
#   -find all empty squares
# player
#   -name
#   -marker
# square
#   -occupied?
#   -mark(marker)
#   -position => moved to the board

class Board
  attr_accessor :data
  WINNING_LINES =  [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize
    # @data = []
    # (1..9).each {|position| @data << Square.new(' ', position)} #If you stored the position in the Square

    @data = {}
    (1..9).each {|position| @data[position] = Square.new(' ')}
  end

  def draw
    empty_line = "     |     |"
    system 'clear'
    puts
    puts empty_line
    puts "  #{@data[1]}  |  #{@data[2]}  |  #{@data[3]}"
    puts empty_line
    puts "-----+-----+-----"
    puts empty_line
    puts "  #{@data[4]}  |  #{@data[5]}  |  #{@data[6]}"
    puts empty_line
    puts "-----+-----+-----"
    puts empty_line
    puts "  #{@data[7]}  |  #{@data[8]}  |  #{@data[9]}"
    puts empty_line
    puts
  end

  def all_squares_marked?
    empty_squares.size == 0
    #I think you can do this:
    # empty_squares.empty?
  end

  def empty_squares
    data.select {|_, square| square.empty?}.values
  end

  def empty_positions
    data.select {|_, square| square.empty?}.keys
  end

  def mark_square(position, marker)
    self.data[position].mark marker
  end

  def winning_condition?(marker)
    WINNING_LINES.each do |line|
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == marker
    end
  end

end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def mark(marker)
    self.value = marker
  end

  def occupied?
    @value != ' '
  end

  def empty?
    @value == ' '
  end

  def to_s
    @value
  end
end

class Player
  attr_reader :marker, :name

  def initialize(name, marker)
    @name = name
    @marker = marker
  end

end

class Game
  attr_accessor :board, :human, :computer
  def initialize
    @board = Board.new
    @human = Player.new("Chris", "X")
    @computer = Player.new("R2D2", "O")
    @current_player = @human
  end

  def current_player_marks_square
    if @current_player == @human
      begin
        puts "Choose a position (1-9): "
        position = gets.chomp.to_i
      end until @board.empty_positions.include?(position)
    else
      position = @board.empty_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def play
    board.draw

    loop do
      current_player_marks_square
      board.draw
      if current_player_win?
        puts "The winner is #{@current_player.name}!"
        break
      elsif board.all_squares_marked?
        puts "It's a tie."
        break
      else
        alternate_player
      end
    end
  end
end

Game.new.play

board = Board.new
board.draw
















