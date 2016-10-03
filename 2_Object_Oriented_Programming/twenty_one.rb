# frozen_string_literal : true

require 'pry'

module Display
  def welcome
    puts "Welcome to twenty one!"
  end

  def clear
    system('clear') || system('cls')
  end

  def show_cards(participant)
    puts "#{participant.name}'s hand is:"
    participant.hand.each { |card| output(card) }
    puts
  end

  def output(card)
    puts "#{card.first} of #{card.last}"
  end

  def show_one_card(participant)
    puts "#{participant.name}'s first card is: "
    output(participant.hand.first)
    puts
  end

  def show_winner(winner)
    puts "#{winner.name} won"
  end

  def show_busted(name)
    puts "\n#{name} busted"
    puts
  end

  def show_tie
    puts "It's a tie"
  end

  def show_play_again_message
    puts "Do you want to play again?"
  end

  def goodbye
    puts "Thanks for playing"
  end
end

class Participant
  include Display
  attr_accessor :hand, :name
  def initialize(name = nil)
    @hand = []
    @name = name
  end

  def hit(deck)
    hand << deck.deal
  end

  def busted?
    total > 21
  end

  def total
    types = hand.map(&:first)
    total = types.inject(0) { |sum, type| sum + value(type) }
    adjust_for_aces(total, types)
  end

  private

  def value(type)
    case type
    when 'Ace'
      11
    when /[King|Queen|Jack]/
      10
    else
      type.to_i
    end
  end

  def adjust_for_aces(subtotal, types)
    ace_count = types.count('Ace')
    while subtotal > 21 && ace_count.positive?
      subtotal -= 10
      ace_count -= 1
    end
    subtotal
  end
end

class Player < Participant
  def set_name
    puts "What is your name?"
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.strip.empty?
      puts "Please enter your name."
    end
    self.name = answer
  end

  def play(deck)
    loop do
      puts "Do you want to hit or stay? (h/s)"
      break if response.start_with? 's'
      hit(deck)
      show_cards(self)
      next unless busted?
      show_busted(name)
      break
    end
  end

  private

  def response
    answer = nil
    loop do
      answer = gets.chomp
      break if ['h', 's'].include? answer.downcase
      puts "You must enter h for hit or s for stay"
    end
    answer
  end
end

class Dealer < Participant
  def play(deck)
    display_start_of_turn_message
    loop do
      break if total > 17
      sleep 1
      puts '...dealing'
      sleep 1
      clear
      hit(deck)
      show_cards(self)
      puts ""
    end
  end

  private

  def display_start_of_turn_message
    puts "Now it's the dealer turn..."
    show_cards(self)
  end
end

class Deck
  SUITS = ['Clubs', 'Diamonds', 'Hearts', 'Spades'].freeze
  TYPE = ['Ace', 'King', 'Queen', 'Jack'] + (2..10).to_a
  attr_accessor :cards

  def initialize
    @cards = TYPE.product(SUITS).shuffle
  end

  def deal
    cards.pop
  end
end

class Game
  include Display
  attr_accessor :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new('Florence the Machine')
  end

  def start
    welcome
    player.set_name
    loop do
      clear
      reset
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
    end
    goodbye
  end

  private

  def reset
    player.hand = []
    dealer.hand = []
    self.deck = Deck.new
  end

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def show_initial_cards
    show_one_card(dealer)
    show_cards(player)
  end

  def player_turn
    player.play(deck)
  end

  def dealer_turn
    dealer.play(deck)
  end

  def play_again?
    show_play_again_message
    response = nil
    loop do
      response = gets.chomp.downcase
      break if ['y', 'n'].include? response
      puts "You must enter 'y' or 'n'"
    end
    response == 'y'
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def both_busted?
    player.busted? && dealer.busted?
  end

  def tie?
    player.total == dealer.total
  end

  def highest_scorer
    return player if player.total > dealer.total
    return dealer if dealer.total > player.total
  end

  def busted_results
    if both_busted?
      puts "Both players busted"
      show_tie
    elsif player.busted?
      show_busted(player.name)
      show_winner(dealer)
    else
      show_busted(dealer.name)
      show_winner(player)
    end
  end

  def show_result
    puts "You scored #{player.total}, dealer scored #{dealer.total}"
    if someone_busted?
      busted_results
    elsif tie?
      show_tie
    else
      show_winner(highest_scorer)
    end
  end
end

Game.new.start
