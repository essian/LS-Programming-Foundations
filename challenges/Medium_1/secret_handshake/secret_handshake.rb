# implements a secret handshake
class SecretHandshake
  ACTION_CODES = { 1 => 'wink',
                   10 => 'double blink',
                   100 => 'close your eyes',
                   1000 => 'jump' }.freeze

  REVERSE_CODE = ACTION_CODES.keys.max * 10

  def initialize(num)
    @num = binary_integer(num)
  end

  def commands
    reverse, num = @num.divmod(REVERSE_CODE)
    commands = (0..num.size).map do |n|
      num, units = num.divmod 10
      units.zero? ? nil : ACTION_CODES[10**n]
    end.compact
    reverse == 1 ? commands.reverse : commands
  end

  private

  def binary_integer(num)
    num = num.to_s(2) if num.is_a? Integer
    num.to_i
  end
end

# handshake = SecretHandshake.new 9
# p handshake.commands # => ["wink","jump"]

# handshake = SecretHandshake.new "110011"
# p handshake.commands # => ["jump","wink"]
