def sum_square_difference(num)
  square_sum = (1..num).to_a.inject(:+) ** 2

  sum_square = (1..num).to_a.inject {|sum, num| sum + num**2}

  square_sum - sum_square


end

p sum_square_difference(3) == 22
p sum_square_difference(10) == 2640
p sum_square_difference(1) == 0
p sum_square_difference(100) == 25164150