class School
  def initialize
    @roster = Hash.new { |hash, key| hash[key] = [] }
  end

  def to_h
    @roster.values.each(&:sort!)
    @roster.sort.to_h
  end

  def add(name, grade)
    @roster[grade] << name
  end

  def grade(grade)
    @roster[grade]
  end
end
