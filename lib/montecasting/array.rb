class Array

  def average
    inject {|sum, el| sum + el}.to_f / size
  end

  def median
    sorted = sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def to_chart
    result = Array.new
    each_with_index {|value, index| result << {x: value, y: yield(index)}  }
    result
  end

end
