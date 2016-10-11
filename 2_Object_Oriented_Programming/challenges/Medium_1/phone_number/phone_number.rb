class PhoneNumber
  FAKE_NUMBER = '0000000000'
  def initialize(str_number)
    @str_number = str_number.gsub(/[^\w]/, '')
  end

  def number
    return FAKE_NUMBER if @str_number.size < 10 ||
                          @str_number.size > 11 ||
                          @str_number =~ /[^0-9]/
    @str_number.slice!(0) if @str_number.size == 11 && @str_number[0] == '1'
    return FAKE_NUMBER if @str_number.size > 10
    @str_number

  end

  def area_code
    number[0, 3]
  end

  def to_s
    "(#{number[0,3]}) #{number[3,3]}-#{number[6..-1]}"
  end
end
