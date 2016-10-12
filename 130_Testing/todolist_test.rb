require 'minitest/autorun'
require "minitest/reporters"

require 'simplecov'
SimpleCov.start
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"
  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
  end

  def test_done
    assert_equal(false, @list.done?)
    @todos.each(&:done!)
    assert_equal(true, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) {@list.add 1}
  end

  def test_add_alias
    new_todo = Todo.new("Walk the dog")
    @list.add(new_todo)
    todos = @todos << new_todo
    assert_equal(todos, @list.to_a)

  end

  def test_item_at
    assert_raises(IndexError) {@list.item_at(100)}
    assert_equal(@todo1, @list.item_at(0))
  end

  def test_mark_done_at
    assert_raises(IndexError) {@list.mark_done_at(100)}
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) {@list.mark_undone_at(100)}
    @todo1.done!
    @todo2.done!
    @list.mark_undone_at(1)
    assert_equal(true, @todo1.done? )
    assert_equal(false, @todo2.done? )
    assert_equal(false, @todo3.done? )
  end

  def test_done
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)

  end

  def remove_at
    assert_raise(IndexError) {@list.remove_at(100)}
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)

  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
  [ ] Buy milk
  [ ] Clean room
  [ ] Go to gym
  OUTPUT

  output_1_done = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
      [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT
    @todo2.done!
    assert_equal(output_1_done, @list.to_s)


  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_return_value
    assert_equal(@list, @list.each {nil} )
  end

  def test_select
    assert_equal(@list.select {|todo| true}.to_s, @list.to_s)
  end

  def test_title
    assert_equal("Today's Todos", @list.title)
  end

  def test_title_equals
    @list.title = "New title"
    assert_equal("New title", @list.title)
  end
end
