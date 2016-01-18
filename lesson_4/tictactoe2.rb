require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
								[[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
								[[1, 5, 9], [3, 5, 7]]
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
INITIAL_MARKER = ' '

def initialize_board
	board = {}
	(1..9). each {|n| board[n] = INITIAL_MARKER}
	board
end

def display_board(board)
	system 'cls'
	puts "   |   |   "
	puts " #{board[1]} | #{board[2]} | #{board[3]} "
	puts "   |   |   "
	puts "------------"
	puts "   |   |   "
	puts " #{board[4]} | #{board[5]} | #{board[6]} "
	puts "   |   |   "
	puts "------------"
	puts "   |   |   "
	puts " #{board[7]} | #{board[8]} | #{board[9]} "
	puts "   |   |   "
end

def update_board_move(board, player_choice, marker)
	board[player_choice] = marker
end

def available_squares(board)
	board.select {|k, v| v == INITIAL_MARKER}.keys
end

def detect_winner(board)
	WINNING_LINES.each do |line|
		if board.values_at(*line).count(PLAYER_MARKER) == 3
			return 'Player'
		elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
			return 'Computer'
		end
	end
end

# def computer_select_square(board)
# 	WINNING_LINES.each do |line|
# 		if board.values_at(line).count(COMPUTER_MARKER) == 2
# 			&&
# 	end



brd = initialize_board
display_board(brd)
loop do
	loop do
		puts "Select the square you want from #{available_squares(brd).to_s}"
		player_choice = gets.chomp.to_i
		if available_squares(brd).include?(player_choice)
			update_board_move(brd, player_choice, PLAYER_MARKER)
			break
		else
			puts "Try again, that's not a valid move"
		end
	end


	display_board(brd)

	if detect_winner(brd) == 'Player'
		puts "You are the winner"
		break
	end
	break if available_squares(brd).size == 0

	computer_choice = computer_select_square(brd)
	update_board_move(brd, computer_choice, COMPUTER_MARKER)
	display_board(brd)
	if detect_winner(brd) == 'Computer'
		puts "You lose"
		break
	end
	
	break if available_squares(brd).size == 0
end

