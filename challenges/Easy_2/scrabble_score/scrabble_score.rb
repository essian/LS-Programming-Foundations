require 'pry'

class Scrabble
  KEY = {
    %w(A E I O U L N R S T) => 1,
    %w(D G) => 2,
    %w(B C M P) => 3,
    %w(F H V W Y) => 4,
    %w(K)=> 5,
    %w(J X) => 8,
    %w(Q Z) => 10
  }

  def initialize(str='')
    @letters = str
  end

  def score
    total = 0
    return total if @letters.nil? || @letters.strip.empty?
    @letters.chars.map(&:upcase).each do |letter|
      group = KEY.keys.detect {|l| l.include? letter}
      total += KEY[group]
    end
    total

  end

  def self.score(str)
    # @letters = str.strip.chars
    # self.score
    new(str).score
  end
end

p Scrabble.new('alacrity').score
