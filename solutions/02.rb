class NumberSet
  include Enumerable

  def initialize(numbers = [])
    @numbers = numbers
  end

  def each(&block)
    @numbers.each(&block)
  end

  def size
    @numbers.size
  end

  def empty?
    @numbers.empty?
  end

  def <<(number)
    @numbers << number unless @numbers.include? number
  end

  def [](filter)
    NumberSet.new @numbers.select { |number| filter.matches? number }
  end
end

class Filter
  def initialize(&block)
    @predicate = block
  end

  def matches?(number)
    @predicate.(number)
  end

  def |(other)
    Filter.new { |number| matches?(number) || other.matches?(number) }
  end

  def &(other)
    Filter.new { |number| matches?(number) && other.matches?(number) }
  end
end

class TypeFilter < Filter
  def initialize(type)
    case type
      when :integer then super() { |number| number.kind_of? Integer }
      when :real    then super() { |number| number.is_a?(Float) ||
                                            number.is_a?(Rational) }
      when :complex then super() { |number| number.is_a? Complex }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
    when :positive     then super() { |number| number > 0  }
    when :negative     then super() { |number| number < 0  }
    when :non_positive then super() { |number| number <= 0 }
    when :non_negative then super() { |number| number >= 0 }
    end
  end
end