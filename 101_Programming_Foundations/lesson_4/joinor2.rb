require 'pry'

def joinor(array, first = ', ', last='or')
  return array.first.to_s if array.size <= 1
  str = array.join(first)
  str[str.rindex(/#{first}/)] = ' ' + last
  str
end

def joinor2(array, first = ', ', last='or')
  return array.first.to_s if array.size <= 1
  str = array.join(first)
  str[str.rindex(/ /)] = ' ' + last + ' '
  str
end


p joinor2([1]) 
p joinor2([1, 2, 3])                # => "1, 2, or 3"
p joinor2([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor2([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"