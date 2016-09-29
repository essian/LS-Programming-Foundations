
# frozen_string_literal: true
# require 'pry'

# Ver1:
# => Added a loop over games; match ends at RPSGame::FIRST_TO.
# => Added score as an instance variable in class RPSGame (removed in ver2).
# => Added Move.quit? to allow early exit.

# Ver2:
# => Added class Match (renamed 'ScoreBoard' in ver4)
#    to keep track of the score and the match status.
# => Added == operator to Move to simplify logic on the < operator.

# Ver3a (rubocop clean):
# => Added 'lizard' and 'Spock' to Move's values.
# => Added a winning message, like "Paper covers rock".
# => Realized that the WINNING_VERB hash actually contains
#    the logic as well, so now I use that (since rubocop complained
#    on the alternative, where I used a long conditional).

# Ver3b (this branch not kept in subsequent versions):
# => Add subclasses to Move: Rock, Paper, Scissors and Quit.
# I don't think this is the best design, b/c I'm essentially
# treating the class name as the state of the object. I think
# the version where the 'Move' state is stored as a string makes
# more sense.

# Ver4 (rubocop clean):
# => Added the History class, and the LogEntry helper class.
# => Added the menu choice 'd' to display the history.
#
# Ver5 (rubocop clean):
# => Added the Strategy class.
# => Gave the computer 'personalities' (ie, diff't strategies).
# => User now chooses the opponent.
# => To test the 'random weighted' functionality, use
#    rps_oo_bonus_test_rand_weighted.rb

class Move
  MOVE_CHOICES = {
    'r' => 'rock',
    'p' => 'paper',
    'x' => 'scissors',
    'l' => 'lizard',
    'v' => 'spock'
  }.freeze

  EXTRA_CHOICES = {
    'q' => 'quit',
    'd' => 'display'
  }.freeze

  ALL_CHOICES = MOVE_CHOICES.merge(EXTRA_CHOICES).freeze

  WINNING_VERB = {
    'rock' => { 'scissors' => 'breaks',
                'lizard' => 'smashes' },
    'paper' => { 'rock' => 'covers',
                 'spock' => 'disproves' },
    'scissors' => { 'paper' => 'cuts',
                    'lizard' => 'slices' },
    'lizard' =>   { 'spock' => 'poisons',
                    'paper' => 'eats' },
    'spock' =>    { 'rock'  => 'vaporizes',
                    'scissors' => 'crushes' }
  }.freeze

  attr_reader :value

  def initialize(choice)
    @value = Move.process(choice)
  end

  def self.list
    MOVE_CHOICES.values
  end

  def self.what_loses_to(choice)
    WINNING_VERB[choice].keys
  end

  def self.display_choices
    puts "\nChoose your move:"
    print " "
    MOVE_CHOICES.each do |short_form, long_form|
      print "#{long_form} (#{short_form}), "
    end
    print "\n d to display the history, or q to quit: "
  end

  def self.valid?(choice)
    ALL_CHOICES.values.include?(choice) ||
      ALL_CHOICES.keys.include?(choice[0])
  end

  def self.process(choice)
    if ALL_CHOICES.keys.include?(choice[0])
      ALL_CHOICES[choice[0]]
    else
      choice
    end
  end

  def self.display_winning_message(choice1, choice2)
    losing_choice, winning_choice = [choice1, choice2].sort
    verb = if winning_choice == losing_choice
             "vs"
           else
             WINNING_VERB[winning_choice.value][losing_choice.value]
           end
    print "#{winning_choice.to_s.capitalize} #{verb} #{losing_choice} -- "
  end

  def quit?
    value == 'quit'
  end

  def display_history?
    value == 'display'
  end

  def >(other_move)
    self != other_move &&
      Move.what_loses_to(value).include?(other_move.value)
  end

  def ==(other_move)
    value == other_move.value
  end

  def !=(other_move)
    !(value == other_move)
  end

  def <(other_move)
    !(self > other_move || self == other_move)
  end

  def <=>(other_move) # to allow sorting
    if self > other_move
      1
    elsif self == other_move
      0
    else
      -1
    end
  end

  def to_s
    value == 'spock' ? value.capitalize : value
  end
end

class Player
  attr_accessor :move, :name
end

class Human < Player
  def initialize
    @name = 'Player'
  end

  def set_name
    n = ""
    loop do
      print "What's your name? "
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n[0].upcase + n[1..-1]
  end

  def choose
    choice = nil
    loop do
      Move.display_choices
      choice = gets.chomp.downcase
      break if Move.valid?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Strategy
  attr_accessor :history

  def self.random_sample
    Move.list.sample
  end

  def self.cumulative(weights)
    # I think this sort of thing would normally belong in a 'Random' module.
    weights = weights.take(Move.list.size)
    cum_wt = 0
    weights.map { |wt| cum_wt += wt }
  end

  def self.random_weighted(weights)
    cum_wts = Strategy.cumulative(weights)
    rand_nb = (1..cum_wts.last).to_a.sample
    choice_idx = cum_wts.find_index { |cum_wt| rand_nb <= cum_wt }
    Move.list[choice_idx]
  end

  def self.deterministic(move, we_win_or_lose)
    their_move = Move.new(move)
    loop do
      our_move = Strategy.random_sample
      break our_move if
        (we_win_or_lose == :win && Move.new(our_move) > their_move) ||
        (we_win_or_lose == :lose && Move.new(our_move) < their_move)
    end
  end

  def choose_move
    Move.new(Move.list[0])
  end

  def self.display_explanation
    # A simple default strategy, so I know if it's been chosen or not:
    puts 'Default strategy -- always choose Rock.'
  end

  def to_s
    self.class.to_s
  end
end

class RandomSample < Strategy
  def choose_move
    Move.new(Strategy.random_sample)
  end

  def self.display_explanation
    puts 'Random sample strategy (equally weighted).'
  end
end

class BeatLastMove < Strategy
  def choose_move
    last_move = history.all_human_moves.last
    if last_move
      Move.new(Strategy.deterministic(last_move, :win))
    else
      Move.new(Strategy.random_sample)
    end
  end

  def self.display_explanation
    puts "Assume the player will repeat his most recent choice."
    puts "Choose a move that beats it."
  end
end

class BeatCurrentMove < Strategy
  def choose_move
    current_move = history.current_human_move
    Move.new(Strategy.deterministic(current_move, :win))
  end

  def self.display_explanation
    puts "Look into the future to see the player's choice."
    puts "Choose a move that beats it."
  end
end

class LoseToCurrentMove < Strategy
  def choose_move
    current_move = history.current_human_move
    Move.new(Strategy.deterministic(current_move, :lose))
  end

  def self.display_explanation
    puts "Look into the future to see the player's choice."
    puts "Choose a move that loses to it."
  end
end

class NoSpockNoLizard < Strategy
  def choose_move
    weights = [100, 100, 100, 0, 0]
    Move.new(Strategy.random_weighted(weights))
  end

  def self.display_explanation
    puts "Traditionalist. Refuse to play Spock or lizard."
  end
end

class AntiSpock < Strategy
  def choose_move
    weights = [0, 100, 0, 100, 50]
    Move.new(Strategy.random_weighted(weights))
  end

  def self.display_explanation
    puts "Will never lose to Spock."
  end
end

class BestGuessUsingHistory < Strategy
  def choose_move
    human_moves = history.all_human_moves
    return Move.new(Strategy.random_sample) if human_moves.empty?

    human_counts = tally(human_moves)
    best_move = best_ai_move(human_counts)

    Move.new(best_move)
  end

  def self.display_explanation
    puts "Use the entire history for the distribution of human choices."
    puts "Choose the best move based on that distribution."
  end

  private

  def tally(human_moves)
    human_counts = Hash.new(0)
    human_moves.each { |move| human_counts[move] += 1 }
    human_counts
  end

  def best_ai_move(human_counts)
    ai_wins = {}
    Move.list.each do |ai_move|
      losing_moves = Move.what_loses_to(ai_move)
      count_ai_wins = losing_moves.map { |mv| human_counts[mv] }
      ai_wins[ai_move] = count_ai_wins.inject(:+)
    end

    best_move = ai_wins.max_by { |_, count| count }
    best_move.first
  end
end

class Computer < Player
  AI_PLAYERS = {
    1 => { name: 'R2D2', strategy: RandomSample },
    2 => { name: 'C3PO', strategy: BeatLastMove },
    3 => { name: 'Hal', strategy: BestGuessUsingHistory },
    4 => { name: 'Data', strategy: AntiSpock },
    5 => { name: 'Sonny', strategy: Strategy },
    6 => { name: 'Smith', strategy: NoSpockNoLizard },
    7 => { name: 'T800', strategy: LoseToCurrentMove },
    8 => { name: 'T1000', strategy: BeatCurrentMove }
  }.freeze

  attr_accessor :ai_player, :strategy

  def self.display_ai_choices
    puts "\nChoose your opponent from the AI team:"
    AI_PLAYERS.each do |k, v|
      puts "  #{k}. #{v[:name]}"
    end
  end

  def self.ai_validate(ai_choice)
    if AI_PLAYERS.keys.include? ai_choice
      AI_PLAYERS[ai_choice]
    else
      puts "Invalid choice. Choosing randomly..."
      AI_PLAYERS[AI_PLAYERS.keys.sample]
    end
  end

  def self.display_strategies
    AI_PLAYERS.each_value do |player|
      print "\n#{player[:name]}: "
      player[:strategy].display_explanation
    end
    puts ""
  end

  def set_ai_player
    Computer.display_ai_choices
    print "\nYour choice (1-#{AI_PLAYERS.size}): "
    ai_choice = gets.chomp.to_i
    self.ai_player = Computer.ai_validate(ai_choice)
    self.name = ai_player[:name]
  end

  def initialize_strategy(history)
    self.strategy = ai_player[:strategy].new
    strategy.history = history
  end

  def choose
    self.move = strategy.choose_move
  end
end

class LogEntry
  attr_accessor :match, :game, :human, :computer, :winner, :loser
  attr_reader :type

  def initialize(type)
    @type = type
  end
end

class History
  attr_accessor :match_count,
                :game_count,
                :history,
                :current_human_move # so the computer can cheat

  def initialize
    @match_count = 0
    @history = []
  end

  def next_match
    self.match_count += 1
    self.game_count = 1
  end

  def next_game
    self.game_count += 1
  end

  def all_human_moves
    move_history = history.select { |entry| entry.type == :game_result }
    move_history.map(&:human)
  end

  def log(entry)
    history << entry
  end

  def log_header(human_name, computer_name)
    entry = LogEntry.new(:header)
    entry.match = 'Match'
    entry.game = 'Game'
    entry.human = human_name
    entry.computer = computer_name
    entry.winner = 'Winner'
    entry.loser = 'Loser'

    log(entry)
  end

  def log_game_result(human_move, computer_move, winner, loser)
    entry = LogEntry.new(:game_result)
    entry.match = match_count
    entry.game = game_count
    entry.human = human_move
    entry.computer = computer_move
    entry.winner = winner
    entry.loser = loser

    log(entry)
  end

  def log_match_result(human_score, computer_score, winner, loser)
    entry = LogEntry.new(:match_result)
    entry.match = match_count
    entry.game = 'final'
    entry.human = human_score
    entry.computer = computer_score
    entry.winner = winner
    entry.loser = loser

    log(entry)
  end

  def display
    puts ""
    history.each do |entry|
      case entry.type
      when :header then print_header(entry)
      when :game_result then print_game_result(entry)
      when :match_result then print_match_result(entry)
      end
    end
    print_break
    puts ""
  end

  def print_break(sym = '=')
    puts sym * 58
  end

  def print_front_half_line(string1, string2 = nil)
    # The point here is that sometimes I merge the
    # first two columns (ie, for the match result).
    col1 = 8
    col2 = 7
    cols = if string2 # no merge
             "  %-#{col1}.#{col1}s%-#{col2}.#{col2}s"
           else       # merge
             "  %-#{col1 + col2}.#{col1 + col2}s"
           end
    print format(cols, string1, string2)
  end

  def print_back_half_line(entry)
    puts format("%-10.10s%-10.10s%-10.10s%-10.10s",
                entry.human,
                entry.computer,
                entry.winner,
                entry.loser)
  end

  def print_header(entry)
    print_front_half_line('Match', 'Game')
    print_back_half_line(entry)
    print_break
  end

  def print_game_result(entry)
    match = (entry.game == 1 ? entry.match : '')
    print_front_half_line(match, entry.game)
    print_back_half_line(entry)
  end

  def print_match_result(entry)
    print_front_half_line('Final score:')
    print_back_half_line(entry)
    print_break('-') unless entry == history.last
  end
end

class ScoreBoard
  attr_accessor :score, :game_winner, :match_status
  attr_reader :first_to

  def initialize(first_to)
    @first_to = first_to
  end

  def reset
    self.score = { human: 0, computer: 0 }
    self.game_winner = :tie
    self.match_status = :continue_playing
  end

  def update_game_winner(human_move, computer_move)
    self.game_winner =
      if human_move > computer_move
        :human
      elsif human_move < computer_move
        :computer
      else
        :tie
      end
  end

  def human_won_game?
    game_winner == :human
  end

  def computer_won_game?
    game_winner == :computer
  end

  def update_score
    if human_won_game? || computer_won_game?
      score[game_winner] += 1
    end
  end

  def human_score
    score[:human]
  end

  def computer_score
    score[:computer]
  end

  def update_match_status
    self.match_status =
      if score[:human] == first_to
        :human_wins
      elsif score[:computer] == first_to
        :computer_wins
      else
        :continue_playing
      end
  end

  def end_of_match?
    human_won_match? || computer_won_match?
  end

  def human_won_match?
    match_status == :human_wins
  end

  def computer_won_match?
    match_status == :computer_wins
  end
end

class RPSGame
  FIRST_TO = 3
  attr_accessor :human, :computer, :scoreboard, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @scoreboard = ScoreBoard.new(FIRST_TO)
    @history = History.new
  end

  def clear_screen
    system("clear")
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts ""
  end

  def onetime_initialization
    human.set_name
    initialize_log
  end

  def initialize_log
    history.log_header(human.name, "AI team")
  end

  def display_instructions
    puts "\nHi #{human.name}! You'll be playing against the AI team."
    puts "The first to #{FIRST_TO} wins the match."
    puts "Type 'q' to quit at any time, or 'd' to display the history."
    puts ""
  end

  def reinit_computer
    computer.set_ai_player
    computer.initialize_strategy(history)
    display_computers_name
  end

  def display_computers_name
    puts "You'll be playing against #{computer.name}."
  end

  def reset_match
    scoreboard.reset
    history.next_match
  end

  def human_choose
    loop do
      human.choose
      break unless human.move.display_history?
      history.display
    end

    history.current_human_move = human.move.value
  end

  def update_scoreboard
    scoreboard.update_game_winner(human.move, computer.move)
    scoreboard.update_score
    scoreboard.update_match_status
  end

  def update_history
    log_game_result

    if scoreboard.end_of_match?
      log_match_result
    else
      history.next_game
    end
  end

  def log_game_result
    history.log_game_result(human.move.value,
                            computer.move.value,
                            *game_winner_loser)
  end

  def log_match_result
    history.log_match_result(scoreboard.human_score,
                             scoreboard.computer_score,
                             *match_winner_loser)
  end

  def game_winner_loser
    if scoreboard.human_won_game?
      [human.name, computer.name]
    elsif scoreboard.computer_won_game?
      [computer.name, human.name]
    else
      ['tie', '']
    end
  end

  def match_winner_loser
    if scoreboard.human_won_match?
      [human.name, computer.name]
    elsif scoreboard.computer_won_match?
      [computer.name, human.name]
    else
      ['match continues', '']
    end
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    Move.display_winning_message(human.move, computer.move)

    winners_name = game_winner_loser.first
    if winners_name == 'tie'
      puts "It's a tie!"
    else
      puts "#{winners_name} wins!"
    end
  end

  def display_score
    puts "\nThe current score is:"
    puts " #{human.name}:\t#{scoreboard.human_score}"
    puts " #{computer.name}:\t#{scoreboard.computer_score}"
    puts ""
  end

  def display_match_winner
    if scoreboard.human_won_match?
      puts "#{human.name} won the set! Way to go!"
    elsif scoreboard.computer_won_match?
      puts "#{computer.name} won the set! Better luck next time!"
    end
  end

  def display_result
    clear_screen
    display_moves
    display_winner
    display_score
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n, or d to display the history)"
      answer = gets.chomp.downcase
      break if ['y', 'n', 'q'].include? answer
      if answer == 'd'
        history.display
      else
        puts "Sorry, must be 'y', 'n' or 'd'."
      end
    end

    answer == 'y'
  end

  def display_strategies
    print "\nWould you like to see the AI strategies? (y/n): "
    answer = gets.chomp.downcase
    Computer.display_strategies if answer == 'y'
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def play_matches
    loop do
      reset_match
      reinit_computer
      loop do
        human_choose
        return if human.move.quit?
        computer.choose
        update_scoreboard
        update_history
        display_result
        break if scoreboard.end_of_match?
      end
      display_match_winner
      return unless play_again?
    end
  end

  def play
    display_welcome_message
    onetime_initialization
    display_instructions
    play_matches
    display_strategies
    display_goodbye_message
  end
end

RPSGame.new.play
