require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
FIRST_PLAYER = 'p' # Valid options are choose, p for player or c for computer
VALID_CHOICES = { player: "p", computer: "c" }

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, delimiter, word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.join(delimiter)
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end
# rubocop:enamble Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def place_piece!(board, current_player)
  if current_player == VALID_CHOICES[:computer]
    computer_places_piece!(board)
  elsif current_player == VALID_CHOICES[:player]
    player_places_piece!(board)
  end
end

def alternate_player(current_player)
  if current_player == VALID_CHOICES[:player]
    current_player = VALID_CHOICES[:computer]
  elsif current_player == VALID_CHOICES[:computer]
    current_player = VALID_CHOICES[:player]
  end
  current_player
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a position to place a piece: #{joinor(empty_squares(brd), ',')}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_best_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def select_square(brd, marker)
  square = nil
  WINNING_LINES.each do |line|
    square = find_best_square(line, brd, marker)
    break if square
  end
  square
end

def computer_places_piece!(brd)
  # offence
  square = select_square(brd, COMPUTER_MARKER)

  # defence
  if !square
    square = select_square(brd, PLAYER_MARKER)
  end

  # pick 5 or just pick a square
  if !square && empty_squares(brd).include?(5)
    square = 5
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def update_score(scores, winner)
  scores[winner.downcase.to_sym] += 1
end

scores = { player: 0, computer: 0 }
choice = ''

if FIRST_PLAYER == 'choose'
  loop do
    prompt "Who starts? (Enter p for player or c for computer})"
    choice = gets.chomp.downcase
    if VALID_CHOICES.values.include?(choice)
      break
    else
      prompt "That's not a valid choice. Please try again."
    end
  end
  current_player = choice
else current_player = FIRST_PLAYER
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    winner = detect_winner(board)
    update_score(scores, winner)
    prompt "#{winner} won!"
  else
    prompt "It's a tie!"
  end

  prompt "Player score is #{scores[:player]} and computer score is #{scores[:computer]}"
  break if scores[:player] == 5 || scores[:computer] == 5
  prompt("Play again? (y or n)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

champion = ''
champion = 'Player' if scores[:player] == 5
champion = 'Computer' if scores[:computer] == 5
prompt "#{champion} is the champion!" unless champion == ''

prompt "Thanks for playing Tic Tac Toe. Goodbye!"
