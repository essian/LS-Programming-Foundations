class Luhn

  def initialize(num)
    @num = num.to_s.chars.reverse.map(&:to_i)
  end

#brute force but since luhn numbers are common the perf hit is low
  def self.create(num)
    num *= 10
    num += 1 until new(num).valid?
    num
  end

  def checksum
    addends.inject(:+)
  end

  def valid?
    checksum % 10 == 0
  end

  def addends
    @num.each_with_index.map do |n, index|
      if index.even?
        n
      else
        n = n * 2
        n > 9 ? n -= 9 : n
      end
    end.reverse
  end

end

luhn = Luhn.new(12_121)
p luhn.addends


number = Luhn.create(873_956)
p number
