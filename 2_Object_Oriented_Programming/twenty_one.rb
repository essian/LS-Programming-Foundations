# frozen_string_literal : true

require 'pry'

module Display
  def welcome
    clear
    puts "Welcome to twenty one!"
  end

  def clear
    system('clear') || system('cls')
  end

  def press_a_key
    puts "Hit enter to continue..."
    gets
  end

  def show_dealing
    sleep 1
    puts '...dealing'
    sleep 1
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

  def show_player_turn_cards(player, dealer)
    clear
    show_one_card(dealer)
    show_cards(player)
  end

  def show_dealer_turn_cards(dealer)
    clear
    puts "Now it's #{dealer.name}'s turn..."
    puts
    show_cards(dealer)
  end

  def show_winner(winner)
    puts "*** #{winner.name} won ***"
  end

  def show_busted(name)
    puts "\n#{name} busted."
    puts
  end

  def show_scores(player, dealer)
    puts "Scores:"
    puts "-------"
    puts "#{player.name}: #{player.total}"
    puts "#{dealer.name}: #{dealer.total}"
    puts
  end

  def show_tie
    puts "It's a tie!"
  end

  def show_play_again_message
    puts "\nDo you want to play again?"
  end

  def goodbye
    puts "Cool, thanks for playing!"
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
    self.name = answer.capitalize
  end

  def play(deck, dealer)
    loop do
      puts "Do you want to hit or stay? (h/s)"
      break if response.start_with? 's'
      hit(deck)
      show_player_turn_cards(self, dealer)
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
    press_a_key
    show_dealer_turn_cards(self)
    loop do
      break if total > 17
      show_dealing
      hit(deck)
      show_dealer_turn_cards(self)
      puts ""
    end
    puts "Dealer is done."
    press_a_key
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
    self.deck = Deck.new # Perhaps each round shouldn't have a new deck?
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
    player.play(deck, dealer)
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

  def busted_player
    player.busted? ? player : dealer
  end

  def player_with_closest_total
    21 - player.total < 21 - dealer.total ? player : dealer
  end

  def unbusted
    player.busted? ? dealer : player
  end

  def busted_results
    if both_busted?
      puts "Both players busted"
      show_tie
    else
      show_busted(busted_player.name)
      show_winner(unbusted)
    end
  end

  def show_result
    clear
    show_cards(player)
    show_cards(dealer)
    show_scores(player, dealer)
    if someone_busted?
      busted_results
    elsif tie?
      show_tie
    else
      show_winner(player_with_closest_total)
    end
  end
end

Game.new.start
