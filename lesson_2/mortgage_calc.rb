# get loan amount and validate
# get apr and validate
# get loan duration and validate
# calculate monthly interest rate
# calculate loan duration in months
# calculate monthly payments and return

def prompt(message)
  puts "=> #{message}"
end

def valid_amount?(amount)
  amount.to_f > 0
end

def valid_apr?(apr)
  apr.to_f > 0
end

def valid_duration?(duration)
  duration.to_i > 0
end

prompt("Welcome to the Mortgage Calculator!")

loop do
  amount, apr, duration = ''

  loop do
    prompt("What is the amount you wish to borrow?")
    amount = gets.chomp
    if valid_amount?(amount)
      break
    else
      prompt("That's not a valid amount, please try again")
    end
  end

  loop do
    prompt("What is the apr in percent? eg enter 5 for 5%")
    apr = gets().chomp()
    if valid_apr?(apr)
      break
    else
      prompt("That's not a valid apr, please try again")
    end
  end

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

  prompt("Your payments would be $#{payment.round(2)} per month")

  prompt("Would you like to do another calculation? (enter Y for yes)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for using the calculator')
