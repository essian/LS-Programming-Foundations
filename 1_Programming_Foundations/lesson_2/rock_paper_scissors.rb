VALID_CHOICES = %w( r p s l v)
SIGN_NAMES = { r: 'rock', p: 'paper', s: 'scissors', l: 'lizard', v: 'spock' }

def prompt(message)
  Kernel.puts("=> #{message}")
end

def letter_to_word(letter)
  case letter
  when 'r' then 'rock'
  when 'p' then 'paper'
  when 's' then 'scissors'
  when 'l' then 'lizard'
  when 'v' then 'spock'
  end
end

def win?(first, second)
  (first == 'rock' && (second == 'scissors' || second == 'lizard')) ||
    (first == 'paper' && (second == 'rock' || second == 'spock')) ||
    (first == 'scissors' && (second == 'paper' || second == 'lizard')) ||
    (first == 'lizard' && (second == 'paper' || second == 'spock')) ||
    (first == 'spock' && (second == 'rock' || second == 'scissors'))
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def update_score(player, computer, scores)
  if win?(player, computer)
    # @player_score += 1
    scores[:player] += 1
  elsif win?(computer, player)
     scores[:computer] += 1
  end
end

def display_score(scores)
  prompt("Player score is #{scores[:player]}")
  prompt("Computer score is #{scores[:computer]}\n")
end

# @player_score = 0
# @computer_score = 0

scores = {player: 0, computer: 0}

letter_prompt = <<-MSG
    Please enter a letter:
    r for rock
    p for paper
    s for scissors
    l for lizard
    v for spock
  MSG

loop do
  letter = ''
  loop do
    prompt(letter_prompt)
    letter = Kernel.gets().chomp()

    if VALID_CHOICES.include?(letter)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  choice = letter_to_word(letter)
  computer_choice = letter_to_word(VALID_CHOICES.sample)

  prompt("You chose #{choice}; computer chose #{computer_choice}")

  display_results(choice, computer_choice)
  update_score(choice, computer_choice, scores)
  display_score(scores)
  if (scores[:player] >= 5)
    prompt("End of the game. You're the champion!")
    break
  elsif (scores[:computer] >= 5)
    prompt("End of the game. You were defeated this time.")
    break
  end

  prompt("Do you want to play again? (Y for yes)")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for playing. Goodbye!')
