class Garden
  PLANTS = { 'C' => :clover, 'R' => :radishes,
             'G' => :grass, 'V' => :violets }.freeze
  KIDS = %w(alice bob charlie david eve fred ginny
            harriet ileana joseph kincaid larry).freeze

  def initialize(garden, students = KIDS)
    @front_row, @back_row = garden.split("\n")
    @students = students.sort.map(&:downcase)
  end

  def method_missing(method_name)
    if @students.include? method_name.to_s
      position = @students.index(method_name.to_s) * 2
      str = @front_row[position, 2] + @back_row[position, 2]
      str.chars.map { |letter| PLANTS[letter] }
    else
      super
    end
  end

  def respond_to_missing?(method_name)
    @students.include? method_name.to_s
  end
end
