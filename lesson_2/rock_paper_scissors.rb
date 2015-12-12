VALID_CHOICES = [:r, :p, :s, :l, :v]
SIGN_NAMES = { r: 'rock', p: 'paper', s: 'scissors', l: 'lizard', v: 'spock' }

def prompt(message)
  Kernel.puts("=> #{message}")
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

def display_score(player, computer)
  prompt("Player score is #{player}")
  prompt("Computer score is #{computer}")
end

@player_score = 0
@computer_score = 0

operator_prompt = <<-MSG
    Please enter a letter:
    r for rock
    p for paper
    s for scissors
    l for lizard
    v for spock
  MSG

loop do
  choice = ''
  loop do
    prompt(operator_prompt)
    choice = Kernel.gets().chomp().to_sym

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  choice = SIGN_NAMES[choice]
  computer_choice = SIGN_NAMES.values.sample

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
