module Blue
  attr_accessor :color
  def initialize
    @color = "blue"
  end

  
end

class Color
  include Blue
end

blue = Color.new
p blue.color