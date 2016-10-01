# frozen_string_literal : true

require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def third_in_the_row(marker)
    initial_marker = Square::INITIAL_MARKER
    square = nil
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      next unless squares.map(&:marker).sort == [
        initial_marker,
        marker,
        marker
      ]
      square = line.find { |index| @squares[index].marker == initial_marker }
    end
    square
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " ".freeze
  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :score, :marker, :name

  def initialize(marker)
    @marker = marker
    @score = 0
    @name = nil
  end
end

class Human < Player
  def set_name
    answer = nil
    loop do
      puts "What is your name?"
      answer = gets.chomp
      break unless answer.strip.empty? || answer.size > 30
      puts "Name cannot be blank or very long"
    end
    self.name = answer
  end

  def set_marker
    new_marker = nil
    loop do
      puts "What marker would you like to use?"
      new_marker = gets.chomp.strip
      break unless new_marker == '' || new_marker.size > 1
      puts "Your marker must be visible, and may only be one character"
    end
    self.marker = new_marker
  end

  def joinor(arr, delimiter=', ', word='or')
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
  end

  def move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice"
    end
    board[square] = marker
  end
end

class Computer < Player
  def set_name
    self.name = %w(Kurt Florence Christine).sample
  end

  def update_marker(human_marker)
    self.marker = name[0]
    self.marker = [*'A'..'Z'].sample while human_marker == marker
  end

  def five_if_available(board)
    board.unmarked_keys.include?(5) ? 5 : false
  end

  def attacking_move(board)
    board.third_in_the_row(marker)
  end

  def defending_move(board, human_marker)
    board.third_in_the_row(human_marker)
  end

  def move(board, human_marker)
    move = attacking_move(board) ||
           defending_move(board, human_marker) ||
           five_if_available(board) ||
           board.unmarked_keys.sample
    board[move] = marker
  end
end

module Display
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_winner(max_score)
    if human.score >= max_score
      puts "You won!"
    elsif computer.score >= max_score
      puts "You lose..."
    end
  end

  def display_board(human, computer, board)
    puts "#{human.name} is a #{human.marker}"
    puts "#{computer.name} is a #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def display_board_and_clear_screen(human, computer, board)
    clear
    display_board(human, computer, board)
  end

  def display_result(human, computer)
    display_board_and_clear_screen(human, computer, board)

    case board.winning_marker
    when human.marker
      puts "#{human.name} won this round!"
    when computer.marker
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie!"
    end
    display_scores(human, computer)
  end

  def display_goodbye_message(max_score)
    display_winner(max_score)
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_scores(human, computer)
    puts ""
    puts "*** Scores ***"
    puts "#{human.name.ljust(35, '-')} #{human.score}"
    puts "#{computer.name.ljust(35, '-')} #{computer.score}"
    puts ""
  end

  def clear
    system('clear') || system('cls')
  end
end

class TTTGame
  include Display

  HUMAN_MARKER = 'X'.freeze
  COMPUTER_MARKER = 'O'.freeze
  MAX_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
    @current_marker = [human.marker, computer.marker].sample
  end

  def play
    welcome_user
    loop do
      display_board(human, computer, board)
      make_moves
      update_score
      display_result(human, computer)
      break if round_over? || not_playing_again?
      reset
      display_play_again_message
    end
    display_goodbye_message(MAX_SCORE)
  end

  private

  def make_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      display_board_and_clear_screen(human, computer, board)
    end
  end

  def choose_own_marker?
    set_marker = nil
    puts "Would you like to choose your own marker (y/n)?"
    loop do
      set_marker = gets.chomp
      break if ['y', 'n'].include?(set_marker.downcase)
      puts "You must enter y or n"
    end
    set_marker.casecmp('y') >= 0
  end

  def welcome_user
    clear
    display_welcome_message
    set_names
    set_markers
    clear
  end

  def set_names
    human.set_name
    computer.set_name
  end

  def set_markers
    if choose_own_marker?
      human.set_marker
      computer.update_marker(human.marker)
    end
  end

  def round_over?
    human.score >= MAX_SCORE || computer.score >= MAX_SCORE
  end

  def update_score
    if board.winning_marker == human.marker
      human.score += 1
    elsif board.winning_marker == computer.marker
      computer.score += 1
    end
  end

  def current_player_moves
    if human_turn?
      human.move(board)
      @current_marker = computer.marker
    else
      computer.move(board, human.marker)
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def not_playing_again?
    answer = nil
    loop do
      puts "Would you like to play again (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end
    answer == 'n'
  end

  def reset
    board.reset
    clear
  end
end

game = TTTGame.new
game.play
