def buy_fruit(array)
	result = []
	array.each do |sub|
		sub[1].times {result << sub[0]}
	end
	p result
	
end

buy_fruit([["apples", 3], ["orange", 1], ["bananas", 2]]) ==
  ["apples", "apples", "apples", "orange", "bananas","bananas"]

