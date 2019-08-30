require "montecasting/version"
require_relative 'numeric'

module Montecasting

  #Metrics class will contains methods to get specific product development metrics pr
  class Metrics
    def self.variance average_closed_points = 0, closed_by_sprint = []
      variance = 0
      closed_by_sprint.each {|spt|
        variance += ((average_closed_points - spt.to_i) ** 2)
      }
      Math.sqrt(variance).round(0)
    end
  end

  # Here will place all those method to generate forecasting charts
  class Forecasting

  end


  #Charts class will contains all those methods to charts data, using rickshaw JS library it's pretty straight forward.
  class Charts

    def self.chart_cycle_time array_of_cycle_times = [], round_to = 0.5
      return unless array_of_cycle_times.all? {|i| i.is_a?(Numeric) }
      data = Array.new {Array.new}
      ct_sorted = array_of_cycle_times.sort.map {|ct| ct.abs.to_f.round(round_to) }
      max_index = ct_sorted.last
      data[0] = [*0..max_index].map {|index| {x: index, y: index}}
      data[1] = [*0..max_index].map {|index| {x: index, y: ct_sorted.count {|elem| elem.eql? index }}}
      data[2] = data[1].map.with_index {|storycount, index| {x: index, y: data[1].take(index).inject(0) {|acc, elem| acc + elem[:y]}.percent_of(ct_sorted.count).round(1)}}
      data
    end
  end
end
