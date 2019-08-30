require "montecasting/version"
require_relative 'numeric'
require_relative 'montecasting/array'

module Montecasting

  #Metrics class will contains methods to get specific product development metrics pr
  class Metrics
    def self.variance array_of_units = []
      variance = 0
      avg = array_of_units.map{|i| i.abs}.average
      array_of_units.each {|spt|
        variance += ((avg - spt) ** 2)
      }
      Math.sqrt(variance)
    end

    def self.wip_limit(array_of_cycle_time, start_date, end_date = DateTime.now)
      (array_of_cycle_time.map(&:abs).average * throughput(array_of_cycle_time.count,start_date,end_date))
    end

    def self.throughput number_of_issues, start_date, end_date =  DateTime.now
      ((number_of_issues).to_f / week_days(start_date,end_date).count)
    end

    def self.week_days start_date, enddate = DateTime.now
      (start_date..enddate).select { |day| !day.sunday? && !day.saturday? }
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
