 require 'pry'

CARDS = (2..10).to_a << 'J' << 'K' << 'K' << 'A'
SUITS = %w(H D S C)

def initialize_deck
  SUITS.product(CARDS).shuffle
end

def prompt(message)
  puts "=> #{message}"
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == 'A'
      sum += 11
    elsif ['J', 'Q', 'K'].include?(value)
      sum += 10
    else
      sum += value.to_i
    end
  end

  values.count { |value| value == 'A' }.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > 21
end

def display_results(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :dealer
    prompt "Dealer wins!"
  when :player
    prompt "Player wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif player_total > dealer_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def play_again?
  puts "-----------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def display_grand_totals(dealer_cards, player_cards, dealer_total, player_total)
  puts "==========="
  prompt "Dealer has #{dealer_cards}, for a total of #{dealer_total}"
  prompt "Player has #{player_cards} for a total of #{player_total}"
  puts "==========="
end

def adjust_score(dealer_cards, player_cards, scores)
  case detect_result(dealer_cards, player_cards)
  when :player_busted || :dealer
    scores[:dealer_score] += 1
  when :dealer_busted || :player_score
    scores[:player_score] += 1
  end
end


loop do
  prompt "Welcome to Twenty-One!"

  deck = initialize_deck
  player_cards = []
  dealer_cards = []
  scores = {player_score: 0, dealer_score: 0}

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]} for a total of #{player_total}"

  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Please enter 'h' or 's'"
    end

    if player_turn == 'h'
      player_cards << deck.pop
      prompt "You chose to hit."
      player_total = total(player_cards)
      prompt "Your cards are now #{player_cards} and your total is #{player_total}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_grand_totals(dealer_cards, player_cards, dealer_total, player_total)
    display_results(dealer_cards, player_cards)
    binding.pry
    adjust_score(dealer_cards, player_cards, scores)
    puts scores
    play_again? ? next : break
  else
    prompt "You stayed at #{player_total}"
  end

  # dealer turn

  prompt "Dealer turn..."

  loop do
    break if busted?(dealer_cards) || total(dealer_cards) > 17

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  dealer_total = total(dealer_cards)
  if busted?(dealer_cards)
    prompt "Dealer total is now: #{dealer_total}"
    display_grand_totals(dealer_cards, player_cards, dealer_total, player_total)
    display_results(dealer_cards, player_cards)
    adjust_score(dealer_cards, player_cards, scores)
    puts scores
    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_total}"
  end

  display_grand_totals(dealer_cards, player_cards, dealer_total, player_total)
  display_results(dealer_cards, player_cards)
  adjust_score(dealer_cards, player_cards, scores)
  break unless play_again?
  
end

prompt "Thank you for playing twenty-one! Goodbye!"
