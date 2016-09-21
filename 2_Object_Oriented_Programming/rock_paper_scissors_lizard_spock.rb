require 'pry'

class Move
  attr_reader :value
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :log
  def initialize
    set_name
    create_log
    @score = 0
  end

  def create_log
    self.log = Move::VALUES.product([0]).to_h
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "You must enter a value. What's your name?"
    end
    self.name = n.capitalize
  end

  def choose
    choice = nil
    loop do
      puts "Please choose from #{Move::VALUES.join(', ')}: "
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry invalid choice"
    end
    self.move = Move.new(choice)
    log[choice] += 1
  end
end

class Computer < Player
  def set_name
    self.name = %w(jilly john jerry).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    log[move.value] += 1
  end
end

# Game Orchestration Engine
class RPSGame
  FIRST_TO = 2

  WINNERS = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['spock', 'rock'],
    'scissors' => ['lizard', 'paper'],
    'spock' => ['rock', 'scissors'],
    'lizard' => ['paper', 'spock']
  }.freeze
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    system 'clear'
    puts "Welcome to rock, paper, scissors, lizard, spock"
  end

  def display_goodbye_message
    puts "Thanks for playing"
  end

  def display_moves
    puts "\n#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def scoring
    if WINNERS[human.move.value].include?(computer.move.value)
      @winner = human.name
      human.score += 1
    elsif WINNERS[computer.move.value].include?(human.move.value)
      @winner = computer.name
      computer.score += 1
    else
      @winner = "No one"
    end
  end

  def display_winner
    puts "\n*** #{@winner} wins ***"
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "You must enter y or n"
    end
    answer.casecmp('y') > -1
  end

  def display_scores
    puts "\nScores: \n"
    puts "-------"
    puts "#{human.name}: #{human.score}, #{computer.name}: #{computer.score}"
  end

  def champion?
    human.score >= FIRST_TO || computer.score >= FIRST_TO
  end

  def display_champion
    champion = human.score >= FIRST_TO ? human : computer
    puts "#{champion.name} is the first to score #{FIRST_TO}."
    puts "#{champion.name} is the champion."
  end

  def display_log(log)
    log.each {|move, count| puts "#{move}: #{count}"}
  end

  def display_logs
    puts "\nYour stats: "
    puts "---------------"
    display_log(human.log)
    puts "\n#{computer.name}'s stats: "
    puts "---------------"
    display_log(computer.log)
  end

  def play
    display_welcome_message
    loop do
      system 'clear'
      human.choose
      computer.choose
      display_moves
      scoring
      display_winner
      display_scores
      display_logs
      if champion?
        display_champion
        break
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
