class Array
  def array_to_hash
    each {|sprint|
      #the string must contain a par elements, first would be the kay and the next one the value
      #Fist step it transforma a string into an array and then creates a hash getting pairs.
      yield Hash[*sprint.chop[(sprint.index('[') + 1)..-1].gsub!('=', ',').split(',')]
    }
  end

  def average
    inject {|sum, el| sum + el}.to_f / size
  end

  def median
    sorted = sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def group_to_hash
    uniq.sort.to_h {|s| [s, count{|elem| elem.equal? s}]}
  end

  def to_chart
    result = Array.new
    each_with_index {|value, index| result << {x: value, y: yield(index)}  }
    result
  end

end
