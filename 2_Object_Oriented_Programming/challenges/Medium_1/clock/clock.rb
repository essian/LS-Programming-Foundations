class Clock

  def initialize(hour, min)
    @hour = hour
    @min = min
    while @min > 60
      @hour += 1
      @min -= 60
    end
    while @hour >= 24
      @hour -= 24
    end
    while @min < 0
      @hour -= 1
      @min += 60
    end
    while @hour < 0
      @hour += 24
    end
  end

  def self.at(hour, min=0)
    new(hour, min)
  end

  def +(mins)
    Clock.new(@hour, @min + mins)
  end

  def to_s
    "#{format('%02d', @hour.to_s)}:#{format('%02d', @min.to_s)}"
  end

  def -(mins)
    Clock.new(@hour, @min - mins)
  end

  def ==(other_clock)
    to_s == other_clock.to_s
  end
end
clock = Clock.at(10) + 3
puts clock
