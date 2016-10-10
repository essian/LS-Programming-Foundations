class PerfectNumber

  def self.classify(num)
    raise RuntimeError unless num > 0
    factors_total = factors(num).inject(:+)
    case
    when factors_total==num
      'perfect'
    when factors_total>num
      'abundant'
    when factors_total < num
      'deficient'
    end

  end

  def self.factors(num)
    highest = num/2
    (1..highest).select { |factor| num % factor == 0 }
  end
end


