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
    self.name = %w(R2D2 Hal Number5 Tik-Tok).sample
  end

  def choose(opponent_log)
    max = opponent_log.values.max
    top_moves = opponent_log.select { |_, v| v == max }.keys
    to_beat = top_moves.sample
    beating_combos = RPSGame::WINNERS.select { |_, v| v.include?(to_beat) }
    self.move = Move.new(beating_combos.keys.sample)
    log[move.value] += 1
  end
end

class R2D2 < Computer
  def set_name
    self.name = "R2D2"
  end

  def choose(_)
    self.move = Move.new('rock')
    log[move.value] += 1
  end
end

class Hal < Computer
  def set_name
    self.name = "Hal"
  end

  def choose(_)
    self.move = Move.new(Move::VALUES.sample)
    log[move.value] += 1
  end
end

class Number5 < Computer
  def set_name
    self.name = "Number5"
  end

  def choose(_)
    n = rand
    self.move = case n
                when 0..0.8
                  Move.new(Move::VALUES.first)
                else
                  Move.new(Move::VALUES.sample)
                end
    log[move.value] += 1
  end
end

class TikTok < Computer
  def set_name
    self.name = "Tik-Tok"
  end

  def choose(opponent_log)
    max = opponent_log.values.max
    top_moves = opponent_log.select { |_, v| v == max }.keys
    to_beat = top_moves.sample
    beating_combos = RPSGame::WINNERS.select { |_, v| v.include?(to_beat) }
    self.move = Move.new(beating_combos.keys.sample)
    log[move.value] += 1
  end
end

# Game Orchestration Engine
class RPSGame
  FIRST_TO = 5

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
    @computer = Number5.new
    # @computer = [R2D2.new, TikTok.new, Number5.new, Hal.new].sample
  end

  def display_welcome_message
    system 'clear'
    puts "Welcome to rock, paper, scissors, lizard, spock"
  end

  def display_goodbye_message
    puts "\nThanks for playing"
  end

  def display_moves
    puts "\n#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def winner(player)
    @winner = player.name
    player.score += 1
  end

  def player_won?(player1, player2)
    WINNERS[player1.move.value].include?(player2.move.value)
  end

  def scoring
    if player_won?(human, computer)
      winner(human)
    elsif player_won?(computer, human)
      winner(computer)
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
    puts "\n#{champion.name} is the first to score #{FIRST_TO}."
    puts "#{champion.name} is the champion."
  end

  def display_log(log)
    log.each { |move, count| puts "#{move}: #{count}" }
  end

  def display_logs
    puts "\nYour stats: "
    puts "---------------"
    display_log(human.log)
    puts "\n#{computer.name}'s stats: "
    puts "---------------"
    display_log(computer.log)
  end

  def display_result
    display_moves
    display_winner
    display_scores
    display_logs
  end

  def play
    display_welcome_message
    loop do
      system 'clear'
      human.choose
      computer.choose(human.log)
      scoring
      display_result
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
