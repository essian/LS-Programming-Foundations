class Employee

  def initialize(name, serial)
    @name = name
    @serial = serial
  end
end

class Exec < Employee
  include Delegation
  def initialize(name, serial)
    super(name, serial)
    @contract = 'Full Time'
    @desk = 'corner'
    @holiday = 20
    @prefix = 'Exe'
  end
end

class Mgr < Employee
  include Delegation
  def initialize(name, serial)
    super(name, serial)
    @contract = 'Full Time'
    @desk = 'private'
    @holiday = 14
    @prefix = 'Mgr'
  end
end

class Regular < Employee
  include Delegation
  def initialize(name, serial)
    super(name, serial)
    @contract = 'Full Time'
    @desk = 'cubicle'
    @holiday = 10
    @prefix = nil
  end
end

class PartTime < Employee
  def initialize
    super(name, serial)
    @contract = 'Part Time'
    @desk = 'hotdesk'
    @holiday = 0
    @prefix = nil
  end
end


Module Delegation
def delegate

end
end
