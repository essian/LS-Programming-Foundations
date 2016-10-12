class Trinary
  attr_reader :num_str
  def initialize(num_str)
    @num_str = num_str
  end

  def to_decimal
    return 0 if num_str.chars.any? {|digit| digit.to_i > 2 }
    num = num_str.to_i
    total = 0
    counter = 0
    num_str.size.times do |n|
      break if num == 0
      num, remainder = num.divmod(10)
      total += remainder * 3**n
    end
    total
  end

end
