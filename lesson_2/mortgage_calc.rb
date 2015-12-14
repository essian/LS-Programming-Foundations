# get loan amount and validate
# get apr and validate
# get loan duration and validate
# calculate monthly interest rate
# calculate loan duration in months
# calculate monthly payments and return

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(number)
  number.to_f > 0
end

def valid_duration?(duration)
  duration.to_i > 0
end

def get_number(name)
  number = gets.chomp
  return number if valid_number?(number)
  prompt("That's not a valid #{name}, please try again")
  get_number(name)
end

prompt("Welcome to the Mortgage Calculator!")

loop do
  duration = '', '', ''

  prompt("What is the amount you wish to borrow?")
  amount = get_number('amount')

  prompt("What is the apr in percent? eg enter 5 for 5%")
  apr = get_number('apr')

  loop do
    prompt("What's the duration of the loan in years")
    duration = gets.chomp
    if valid_duration?(duration)
      break
    else
      prompt("Please enter a valid duration")
    end
  end

  duration_months = duration.to_f * 12
  monthly_rate = (apr.to_f / 100) / 12

  x = (1 + monthly_rate)**duration_months
  payment = amount.to_f * ((monthly_rate * x) / (x - 1))

  prompt("Your payments would be $#{'%.2f' % payment} per month")

  prompt("Would you like to do another calculation? (enter Y for yes)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for using the calculator')
