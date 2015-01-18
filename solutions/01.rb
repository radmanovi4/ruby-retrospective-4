def series(sequence, index)
  case sequence
    when 'fibonacci' then fibonacci(index)
    when 'lucas'     then lucas(index)
    else fibonacci(index) + lucas(index)
  end
end

def fibonacci(index)
  case index
    when 1, 2 then 1
    else fibonacci(index - 1) + fibonacci(index - 2)
  end
end

def lucas(index)
  case index
    when 1 then 2
    when 2 then 1
    else lucas(index - 1) + lucas(index - 2)
  end
end
