class SequenceMemberGenerator
  def initialize(first_element, second_element)
    @sequence_store = Hash.new do |sequence, index|
      sequence[index] = sequence[index - 1] + sequence[index - 2]
    end
    @sequence_store[1] = first_element
    @sequence_store[2] = second_element
  end

  def [](index)
    @sequence_store[index]
  end
end

class Fibonacci
  def initialize
    @@fibonacci_sequence ||= SequenceMemberGenerator.new(1, 1)
  end

  def [](index)
    @@fibonacci_sequence[index]
  end
end

class Lucas
  def initialize
    @@lucas_sequence ||= SequenceMemberGenerator.new(2, 1)
  end

  def [](index)
    @@lucas_sequence[index]
  end
end

class Summed
  def [](index)
    Fibonacci.new[index] + Lucas.new[index]
  end
end

def series(name, index)
  if name == 'fibonacci'
    Fibonacci.new[index]
  elsif name == 'lucas'
    Lucas.new[index]
  else
    Summed.new[index]
  end
end