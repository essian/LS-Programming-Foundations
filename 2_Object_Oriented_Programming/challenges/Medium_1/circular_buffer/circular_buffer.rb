class BufferEmptyException < StandardError; end
class BufferFullException < StandardError; end

class CircularBuffer
  attr_reader :size, :buffer, :read_cycle, :write_cycle
  def initialize(size)
    @size = size
    setup
  end

  def setup
    @buffer = (1..size).map { [] }
    @write_cycle = buffer.cycle
    @read_cycle = buffer.cycle
  end

  def read
    raise BufferEmptyException if buffer_empty?
    read_cycle.next.pop
  end

  def write(str)
    raise BufferFullException if buffer_full?
    return if str.nil?
    write_cycle.next << str
  end

  def write!(str)
    return if str.nil?
    if buffer_not_full?
      write(str)
    else
      read_cycle.next
      write_cycle.next.push(str).shift
    end
  end

  alias clear setup

  private

  def buffer_full?
    buffer.none?(&:empty?)
  end

  def buffer_empty?
    buffer.all?(&:empty?)
  end

  def buffer_not_full?
    buffer.any?(&:empty?)
  end
end
