class Phrase
  def initialize(str)
    @words = str.downcase.gsub(',', ' ').scan(/\b\S+\b/)
  end

  def word_count
    count = Hash.new(0)
    @words.each do |word|
      count[word] += 1
      end
      count
  end
end
phrase = Phrase.new('word hello jane hello')
p phrase.word_count
