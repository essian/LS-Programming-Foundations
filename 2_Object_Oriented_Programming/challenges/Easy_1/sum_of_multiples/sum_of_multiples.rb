class SumOfMultiples
  attr_reader :multipliers
  def initialize(*args)
    @multipliers = args
  end

  def self.to(num)
    @multipliers ||= [3, 5]
    return 0 if num <=1
    total = 0
    array = (1...num).to_a
    array.each do |n|
      @multipliers.each do |m|
        if n%m == 0
          total += n
          break
        end
      end
    end
    total

  end

  def to(num)
    total = []
    array = (1...num).to_a
    array.each do |n|
      @multipliers.each do |m|
        if n%m == 0
          total << n
          break
        end
      end
    end
    total.compact.inject(:+)
  end
end

# p SumOfMultiples.new(4, 6).to(15)

p SumOfMultiples.to(1000)
