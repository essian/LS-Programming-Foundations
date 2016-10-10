class Series
  attr_reader :int_array
  def initialize(str)
    @int_array = str.chars.map(&:to_i)
  end

  def slices(slice_size)
    raise ArgumentError if slice_size > int_array.size
    start_indices = (0..int_array.size - slice_size)
    start_indices.to_a.map { |index| int_array.slice(index, slice_size) }
  end
end



# class Series
#   attr_reader :arr
#   def initialize(str)
#     @arr = str.chars.map(&:to_i)
#   end

#   # def slices(size)
#   #   raise ArgumentError if size > arr.size
#   #   result = []
#   #   repeats = arr.size - size + 1
#   #   repeats.times do |n|
#   #     result << arr.slice(n, size)
#   #   end
#   #   result
#   # end

#   def slices(size)
#     raise ArgumentError if size > arr.size
#     start_indices = (0..arr.size - size).to_a
#     start_indices.map { |index| arr.slice(index, size) }
#   end


#   # def slices(size)
#   #   raise ArgumentError if size > arr.size

#   #   result = []
#   #   arr.each_with_index do |item, index|
#   #       sub_arr = arr.slice(index, size)
#   #     result << sub_arr if sub_arr.size == size
#   #   end
#   #   result.select {|item| item.size == size}
#   # end

#   # def slices(size)
#   #   raise ArgumentError if size > arr.size
#   #   counter = -1
#   #   arr.map do |item|
#   #     counter+=1
#   #     sub_array = arr[counter..counter+size-1]
#   #     next if sub_array.size < size
#   #     sub_array
#   #   end.compact

#   # end

# end

# # series = Series.new('01234')
# #     p series.slices(1)
