require 'yaml'
MESSAGES = YAML.load_file('mortgage_calc_messages.yml')

MONTHS_IN_YEAR = 12

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(str)
  integer(str) || float(str)
end

def valid_apr?(apr)
  valid_amount?(apr) && apr.to_f <= 100
end

def integer(loan)
  loan.to_i.to_s == loan

end

def float(loan)
  /^\d+\.?\d*$/.match(loan)
end

prompt(MESSAGES['welcome'])
loan = 0
apr = 0

loop do
  prompt(MESSAGES['get_loan_amount'])
  loan = gets.chomp
  if valid_number?(loan)
    break
  else
    prompt(MESSAGES['invalid input'])
  end
end

loop do
  prompt(MESSAGES['get_interest_rate'])
  apr = gets.chomp

  if valid_apr?(apr)
    break
  else
    prompt(MESSAGES['invalid_input'])
  end
end


prompt(MESSAGES['get_duration'])
duration_years = gets.chomp.to_f

monthly_rate = apr/12.0
duration_months = duration_years * MONTHS_IN_YEAR

monthly_payment = loan * (monthly_rate / (1 - (1+monthly_rate)**-duration_months))

prompt "Monthly payment is $#{format('%02.2f', monthly_payment}"
