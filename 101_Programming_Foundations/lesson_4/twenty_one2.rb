require 'pry'

SUITS = %w(clubs diamonds hearts spades).freeze
VALUES = (2..10).to_a + %w(a k q j).freeze

def initialize_deck
  deck = []
  SUITS.each do |s|
    VALUES.each do |v|
      card = [v, s]
      deck << card
    end
  end
  deck.shuffle
end

def deal_cards(quantity, deck, hand)
  quantity.times { hand << deck.pop }
end

def sum_cards(hand)
  values = hand.map do |card|
    value = card[0]
    case value
    when 'k', 'q', 'j' then 10
    when 'a' then 11
    else value.to_i
    end
  end
  values.inject(:+)
end

def cards_total(hand)
  aces = count_aces(hand)
  total = sum_cards(hand)
  total = adjust_total_for_aces(total, aces) if aces && total > 21
  total
end

def count_aces(hand)
  hand.count { |card| card.first == 'a' }.nonzero?
end

def adjust_total_for_aces(total, aces)
  aces.times do
    total -= 10
    break if total < 21
  end

  total
end

def bust?(hand)
  cards_total(hand) > 21
end

def display_user_cards(hand)
  puts "You have: "
  hand.each { |card| p card }
end

def display_dealer_cards(hand, quantity= 'all')
  puts "Dealer has: "
  if quantity == 1
    puts "#{hand.first} and ?"
  else
    hand.each { |card| p card }
  end
end

def detect_winner(user_hand, dealer_hand)
  case cards_total(user_hand) <=> cards_total(dealer_hand)
  when 1 then 'You'
  when -1 then 'Computer'
  else 'No one'
  end
end

user_hand = []
dealer_hand = []
deck = initialize_deck
deal_cards(2, deck, user_hand)
deal_cards(2, deck, dealer_hand)

puts "Welcome to 21"

loop do
  display_user_cards(user_hand)
  display_dealer_cards(dealer_hand, 1)
  puts "What do you want to do?"
  answer = ' '
  loop do
    puts "Enter 'h' for hit or 's' for stay."
    answer = gets.chomp.downcase
    break if answer.start_with?('h', 's')
  end
  break if answer == 's'
  deal_cards(1, deck, user_hand)
  if bust?(user_hand)
    display_cards(user_hand, dealer_hand)
    puts "You're bust, computer wins"
    exit
  end
end

puts "Now the computer turn"

while cards_total(dealer_hand) <= 17
  puts "Press any key to see what happens next..."
  response = gets.chomp
  puts "Computer hits..."
  sleep 2
  deal_cards(1, deck, dealer_hand)
  display_user_cards(user_hand)
  display_dealer_cards(dealer_hand)
end

if bust?(dealer_hand)
  puts "The dealer busted. You win"
  exit
end

puts "Computer stays"

winner = detect_winner(user_hand, dealer_hand)
puts "You scored: #{cards_total(user_hand)}"
puts "Computer scored: #{cards_total(dealer_hand)}"
puts "#{winner} won!"
