VALID_CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
	puts "=> #{message}"
end

def calculate_result(player_choice, computer_choice)
	if player_choice == 'rock' && computer_choice == 'paper'
		'Computer'
	elsif player_choice == 'rock' && computer_choice == 'scissors'
		'Player'
	elsif player_choice == 'scissors' && computer_choice == 'paper'
			'Player'
	elsif player_choice == 'scissors' && computer_choice == 'rock'
			'Computer'
	elsif player_choice == 'paper' && computer_choice == 'scissors'
			'Computer'
	elsif player_choice == 'paper' && computer_choice == 'rock'
			'Player'
	else
		'Nobody'
	end
end

play_again = true

while play_again
	prompt "Welcome to rock paper scissors"
	prompt "Please select rock paper or scissors"
	player_choice = gets.chomp.downcase

	computer_choice = VALID_CHOICES.sample

	prompt "Computer chose #{computer_choice}"

	winner = calculate_result(player_choice, computer_choice)
	prompt "#{winner} wins"
	prompt "Would you like to play again?"
	play_again = false if gets.chomp.downcase == 'n'
end

prompt "Thanks for playing!"