require 'montecasting/array'
require 'montecasting/hash'

class Chart
  include Enumerable

  def initialize(arry_times)
    @elements = arry_times
  end

  def each(&block)
    @elements.each(&block)
  end

  def <=>(other_value)
    self <=> other_value
  end

  def legend
    to_h.to_chart()
  end

  def group_by
    to_h.to_chart(&:to_i)
  end

  def percent_of
    to_h.to_chart {|value| value.percent_of(count).ceil(0)}
  end

  def cumulative
    to_h.keys.to_chart {|index| to_h.values.take(index).inject(0) {|acc, elem| acc + elem}.percent_of(count).ceil(0)}

  end

  def to_h
    uniq.sort.to_h {|s| [s, count{|elem| elem.equal? s}]}
  end

end
