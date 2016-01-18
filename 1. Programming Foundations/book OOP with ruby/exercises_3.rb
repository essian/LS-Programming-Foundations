class Person
  attr_accessor :name

  def initialize(n)
    self.name = n
  end
end

jess = Person.new('jess')

puts jess.name