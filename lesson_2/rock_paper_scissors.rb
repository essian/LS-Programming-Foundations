VALID_CHOICES = %w( r p s l v)
SIGN_NAMES = { r: 'rock', p: 'paper', s: 'scissors', l: 'lizard', v: 'spock' }

def prompt(message)
  Kernel.puts("=> #{message}")
end

def letter_to_word(letter)
  case letter
    when 'r'
      'rock'
    when 'p'
      'paper'
    when 's'
      'scissors'
    when 'l'
      'lizard'
    when 'v'
      'spock'
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

def update_score(player, computer)
  if win?(player, computer)
    @player_score += 1
  elsif win?(computer, player)
    @computer_score += 1
  end
end

def display_score(player_score, computer_score)
  prompt("Player score is #{player_score}")
  prompt("Computer score is #{computer_score}\n")
end

@player_score = 0
@computer_score = 0

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
  update_score(choice, computer_choice)
  display_score(@player_score, @computer_score)
  if (@player_score >= 5)
    prompt("End of the game. You're the champion!")
    break
  elsif (@computer_score >= 5)
    prompt("End of the game. You were defeated this time.")
    break
  end

  prompt("Do you want to play again? (Y for yes)")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for playing. Goodbye!')
