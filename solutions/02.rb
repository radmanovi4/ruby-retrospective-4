require 'set'

class NumberSet
  include Enumerable

  def initialize
    @numbers = Set.new
  end

  def << (number)
    unless @numbers.any? { |element| element == number }
      @numbers << number
    end
    self
  end

  def empty?
    @numbers.empty?
  end

  def size
    @numbers.size
  end

  def each
    return to_enum(:each) unless block_given?
    @numbers.each { |element| yield element }
  end

  def [](filter)
    @numbers.each_with_object(NumberSet.new) do |number, new_set|
      new_set << number if filter.satisfies?(number)
    end
  end
end

module NumbersFilter
  def satisfies?(number)
    @condition.call number
  end

  def &(filter)
    Filter.new do |number|
      self.satisfies?(number) && filter.satisfies?(number)
    end
  end

  def |(filter)
    Filter.new do |number|
      self.satisfies?(number) || filter.satisfies?(number)
    end
  end
end

class Filter
  include NumbersFilter

  def initialize(&condition)
    @condition = condition
  end
end

class TypeFilter
  include NumbersFilter

  def initialize(type)
    case type
      when :integer
        @condition = proc { |n| n.integer? }
      when :real
        @condition = proc { |n| n.class == Float || n.class == Rational }
      when :complex
        @condition = proc { |n| n.class == Complex }
    end
  end
end

class SignFilter
  include NumbersFilter

  def initialize(condition)
    if condition == :positive
        @condition = proc { |element| element > 0 }
      elsif condition == :non_positive
        @condition = proc { |element| element <= 0 }
      elsif condition == :negative
        @condition = proc { |element| element < 0 }
      elsif condition == :non_negative
        @condition = proc { |element| element >= 0 }
    end
  end
end
