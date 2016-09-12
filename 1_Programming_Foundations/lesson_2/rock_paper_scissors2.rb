VALID_CHOICES = %w(rock paper scissors)

def prompt(message)
  puts("=> #{message}")
end

choice = ''
loop do
  prompt("Choose one: #{VALID_CHOICES.join(', ')}")
  choice = gets.chomp

  if VALID_CHOICES.include?(choice)
    break
  else
    prompt("That's not a valid choice.")
  end
end
computer_choice = VALID_CHOICES.sample

puts "You chose #{choice}, computer chose #{computer_choice}"

if (choice == 'rock' && computer == 'scissors') ||
  prompt("You won!")
elsif choice