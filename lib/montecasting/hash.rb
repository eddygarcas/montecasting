class Hash
  def to_chart
    result = Array.new
    each {|key, value| result << {x: key, y: yield(value)}  }
    result
  end
end
