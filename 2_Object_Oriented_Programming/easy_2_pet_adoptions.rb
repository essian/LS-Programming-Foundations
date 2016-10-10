require 'pry'

class Pet
  attr_reader :type, :name
  def initialize(type, name)
    @type = type
    @name = name
  end
end

class Owner
  attr_reader :name
  attr_accessor :number_of_pets

  def initialize(name)
    @name = name
    @number_of_pets = 0
  end
end

class Shelter

  def initialize
    @adoptions = Hash.new {|h, k| h[k] = []}
  end

  def adopt(owner, animal)
    owner.number_of_pets += 1
    @adoptions[owner] << animal
  end

  def print_adoptions
    @adoptions.each do |owner, pets|
      puts "#{owner.name} has adopted the following pets:"
      pets.each {|pet| puts "#{pet.type} name #{pet.name}"}
      puts
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
