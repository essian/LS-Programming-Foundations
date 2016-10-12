class Anagram
  attr_reader :word
  def initialize(word)
    @word = word
  end

  def match(array)
    array.select do |anagram|
      letters(word) == letters(anagram) unless word.downcase == anagram.downcase
    end
  end

  private

  def letters(word)
    word.downcase.chars.sort
  end

end

detector = Anagram.new('diaper')
p detector.match(%w(hello world zombies pants))
