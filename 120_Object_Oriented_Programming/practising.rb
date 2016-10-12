def fibonacci(n)
  return 1 if n == 1 || n == 2
  fibonacci(n-1) + fibonacci(n-2)

end

p fibonacci(10)

def prime(num)
  2.upto(Math.sqrt(num)) do |n|
    return false if num % n == 0
  end
  true
end

def primes(a, b)
	(a..b).select { |num| prime(num) }
end

p prime(6)
p primes(1, 10)
