require 'montecasting/version'
require 'montecasting/numeric'
require 'montecasting/array'
require 'montecasting/hash'
require 'matrix'

module Montecasting

  #Metrics class will contains methods to get specific product development metrics pr
  class Metrics
    def self.variance(array_of_times = [])
      return nil unless array_of_times.all? Numeric
      variance = 0
      avg = array_of_times.map(&:abs).average
      array_of_times.each {|spt|
        variance += ((avg - spt) ** 2)
      }
      Math.sqrt(variance)
    end

    def self.median(array_of_times = [])
      return nil unless array_of_times.all? Numeric
      array_of_times.map(&:abs).median
    end

    def self.wip_limit(array_of_times, start_date, end_date = DateTime.now)
      return nil unless array_of_times.all? Numeric
      (array_of_times.map(&:abs).average * throughput(array_of_times.count, start_date, end_date))
    end

    def self.throughput(number_of_issues, start_date, end_date = DateTime.now)
      return nil unless number_of_issues.is_a? Numeric
      ((number_of_issues).to_f / week_days(start_date, end_date).count)
    end

    def self.week_days(start_date, end_date = DateTime.now)
      (start_date..end_date).select {|day| !day.sunday? && !day.saturday?}
    end

    def self.percent_of_items_at(array_of_times, time_units = 0)
      return nil unless array_of_times.all? Numeric
      array_of_times.select {|time| time < time_units}.count.percent_of(array_of_times.count)
    end
  end

  # Here will place all those method to generate forecasting charts
  class Forecasting

    def self.takt_times(cycle_time = [], rand_generator = 1000)
      return nil unless cycle_time.all? Numeric
      result = Matrix.build(rand_generator, cycle_time.count) {cycle_time.at(rand(0...cycle_time.count))}
      result.row_vectors.map {|r| (r.inject(:+).to_f / cycle_time.count).round(2)}
    end

    def self.montecarlo(takt_times = [], backlog_items = 0, days_iteration = 0)
      return nil unless takt_times.all? Numeric
      takt_times.map {|tt| ((tt * backlog_items) / days_iteration).round(0)}.sort
    end

  end

  #Charts class will contains all those methods to charts data, using rickshaw JS library it's pretty straight forward.
  class Charts

    def self.chart_takt_times(array_of_times = [])
      return nil unless array_of_times.all? Numeric
      chart_builder Forecasting.takt_times(array_of_times)&.sort.group_to_hash
    end

    def self.chart_montecarlo(array_of_times = [], backlog_items = 0, days_iteration = 0)
      return nil unless array_of_times.all? Numeric
      chart_builder Forecasting.takt_times(array_of_times)&.map! {|elem| ((elem * backlog_items) / days_iteration).ceil(0)}.group_to_hash
    end

    def self.chart_cycle_time(array_of_times = [], round_to = 0.5)
      return nil unless array_of_times.all? Numeric
      data = Array.new {Array.new}
      ct_sorted = array_of_times.sort.map {|ct| ct.abs.to_f.round(round_to)}
      max_index = ct_sorted.last
      data[0] = [*0..max_index].map {|index| {x: index, y: index}}
      data[1] = [*0..max_index].map {|index| {x: index, y: ct_sorted.count {|elem| elem.eql? index}}}
      data[2] = data[1].map.with_index {|sc, index| {x: index, y: data[1].take(index).inject(0) {|acc, elem| acc + elem[:y]}.percent_of(ct_sorted.count).round(1)}}
      data
    end

    private

    def self.chart_builder chart_hash = {}
      [series_legend(chart_hash), series_percent_of(chart_hash), series_comulative(chart_hash)]
    end

    def self.series_legend chart_hash = {}
      chart_hash.to_chart(&:to_i)
    end

    def self.series_percent_of chart_hash = {}
      chart_hash.to_chart {|value| value.percent_of(1000).ceil(0)}
    end

    def self.series_comulative chart_hash = {}
      chart_hash.keys.to_chart {|index| chart_hash.values.take(index).inject(0) {|acc, elem| acc + elem}.percent_of(1000).ceil(0)}
    end
  end
end
