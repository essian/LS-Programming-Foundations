require 'pry'

class Fixnum

  THOUSANDS = %w( M MM MMM).unshift ''
  HUNDREDS = %w( C CC CCC CD D DC DCC DCCC CM).unshift ''
  TENS = %w( X XX XXX XL L LX LXX LXXX XC).unshift ''
  UNITS = %w( I II III IV V VI VII VIII IX).unshift ''

  def to_roman
    enum = [UNITS, TENS, HUNDREDS, THOUSANDS].each
    result = ''
    remainder = self
    until remainder == 0
      remainder, count = remainder.divmod 10
      result.prepend enum.next[count]
    end
    result
  end
end

