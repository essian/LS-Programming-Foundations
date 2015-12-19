def joinor(array, delimiter = ', ', word = 'or')
  
  array[0...(array.size - 1)].join(delimiter) + "#{delimiter} #{word} " + array.last.to_s


end

puts joinor([1, 2, 3])

puts joinor([1, 2, 3], '; ')

puts joinor([1, 2, 3], '; ', 'and')