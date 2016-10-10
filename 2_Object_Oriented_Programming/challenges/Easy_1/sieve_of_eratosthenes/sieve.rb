class Sieve
  attr_reader :range
  def initialize(num)
    @range = (2..num).to_a
  end

  def primes
    sieve = range.dup
    range.each do |n|
      sieve.each do |m|
        sieve.delete(m)if (m % n == 0 && n != m)
      end
    end
    sieve
  end


end



