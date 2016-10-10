require 'minitest/autorun'


require_relative 'cash_register'
require_relative 'transaction'

class CashRegisterTest < Minitest::Test

  def test_accept_money
    cr = CashRegister.new(10)
    tr = Transaction.new(10)
    tr.amount_paid = 10
    assert_equal 20, cr.accept_money(tr)

  end

  def test_change
    cr = CashRegister.new(10)
    tr = Transaction.new(5.75)
    tr.amount_paid = 10
    assert_equal 4.25, cr.change(tr)
  end

  def test_give_receipt
    cr = CashRegister.new(10)
    tr = Transaction.new(5.75)
    assert_output("You've paid $5.75.\n") {cr.give_receipt(tr)}
  end

  def test_prompt_for_payment
    cr = CashRegister.new(10)
    tr = Transaction.new(3.00)
    assert_output("You owe $#{tr.item_cost}.\nHow much are you paying?\n") {tr.prompt_for_payment}

  end
end
