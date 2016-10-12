# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

class TodoList
  attr_accessor :title, :todos

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(item)
    raise TypeError, 'Can only add Todo objects' unless item.is_a?(Todo)
    todos << item
  end

  alias_method :<<, :add

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def item_at(index)
    todos.fetch index
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    todos.delete(item_at(index))
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def each
    counter = 0
    while counter < todos.size
      yield todos[counter]
      counter += 1
    end
    self
  end

  def select
    result = TodoList.new(title)
    each do |item|
      result << item if yield item
    end
    result
  end

  def find_by_title(str)
    select {|item| item.title == str }.first
  end

  def all_done
    select {|item| item.done? }
  end

  def all_not_done
    select {|item| !item.done? }
  end

  def mark_done(str)
    find_by_title(str) && find_by_title(str).done!
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)


puts list.find_by_title("Buy milk")
puts list.all_done
puts list.all_not_done
list.mark_all_done
puts list
list.mark_all_undone
puts list
list.mark_done('jessy')


