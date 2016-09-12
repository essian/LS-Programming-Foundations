require 'SecureRandom'

def uuid
  num = SecureRandom.hex
  num[0, 8] + '-' + num[8, 4] + '-' + num[12, 4] + '-' + num[16, 8]


end

puts uuid