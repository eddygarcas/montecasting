require 'montecasting/version'
require 'montecasting/numeric'
require 'montecasting/chart'

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

    def self.montecarlo(takt_times = [], backlog_items = 1, days_iteration = 1)
      return nil unless takt_times.all? Numeric
      takt_times.map {|tt| ((tt * backlog_items) / days_iteration).round(0)}.sort
    end

  end

  #Charts class will contains all those methods to charts data, using rickshaw JS library it's pretty straight forward.
  class Charts

    def self.chart_takt_times(array_of_times = [])
      return nil unless array_of_times.all? Numeric
      chart_builder Forecasting.takt_times(array_of_times)&.sort
    end

    def self.chart_montecarlo(array_of_times = [], backlog_items = 0, days_iteration = 0)
      return nil unless array_of_times.all? Numeric
      chart_builder Forecasting.takt_times(array_of_times)&.map! {|elem| ((elem * backlog_items) / days_iteration).ceil(0)}
    end

    def self.chart_cycle_time(array_of_times = [], round_to = 0.5)
      return nil unless array_of_times.all? Numeric
      ct_sorted = array_of_times.sort.map {|ct| ct.abs.to_f.round(round_to)}
      chart = Chart.new(ct_sorted)
      [chart.group_by,chart.cumulative(ct_sorted.count)]
    end

    private

    def self.chart_builder chart_hash
      chart = Chart.new(chart_hash)
      [chart.group_by, chart.percent_of, chart.cumulative]
    end

  end
end
