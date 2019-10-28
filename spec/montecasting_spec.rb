require 'time'
require 'matrix'
RSpec.describe Montecasting do

  variance_array = [1,1,1,1,0,1,1,2,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

  array_of_cycle_times = [87,32,0,0,114,114,105,108,103,89,0,77,89,223,69,18,99,102,114,0,114,0,0,0,65,84,165,0,0,0,0,0,0,0,0,40,1,0,0,0,0]

  ct_values = [0.33,	0.36,	0.38,	0.36,	0.33,	0.33,	0.42,	0.36,	0.33]


  it "has a version number" do
    expect(Montecasting::VERSION).not_to be nil
  end

  it "returns data to build a cycle time chart" do
    result = Montecasting::Charts.chart_cycle_time(array_of_cycle_times,0)
    pp result.take(5)
    expect(result).not_to be nil
  end

  it "returns nil if the array contains something other than numerics" do
    result = Montecasting::Charts.chart_cycle_time([0.1, 0.1, 0.1, '0.2', 0.13454],0)
    expect(result).to be nil
  end

  it "returns nil if the number of issues value is not a numberic" do
    result = Montecasting::Metrics.throughput "34",DateTime.now,DateTime.now
    expect(result).to be nil
  end
  it "Calculates the variance that should be 2.43 for the array given" do
    result = Montecasting::Metrics.variance variance_array
    expect(result.round(2)).to be 2.43
  end

  it "WIP limit for a given array of items" do
    result = Montecasting::Metrics.wip_limit array_of_cycle_times, (DateTime.now - 60),  DateTime.now
    expect(result.round(2)).to be_between(43.to_f,47.to_f)
  end

  it "Calculate the throughput" do
    result = Montecasting::Metrics.throughput array_of_cycle_times.count,  (DateTime.now - 60),  DateTime.now
    expect(result.round(2)).to be_between(0.91.to_f,0.99.to_f)
  end

  it "Percentage of cycle time at 2 days for instance" do
    result = Montecasting::Metrics.percent_of_items_at array_of_cycle_times,80
    expect(result.round(0)).to be 63

  end

  it "get a combination of #ocurences of the cycle time array" do
      result = Montecasting::Forecasting.takt_times ct_values,1000
      expect(result).not_to be nil
  end

  it "Get the project prediction from an array of takt times" do
    takt_times = Montecasting::Forecasting.takt_times ct_values,1000
    result = Montecasting::Forecasting.montecarlo takt_times,200,5
    expect(result.include? 14).to be true
    expect(result.include? 15).to be true
    expect(result.include? 17).to be false
  end

  it "Send empty array to get the takt times" do
    result = Montecasting::Forecasting.takt_times [],1000
    expect(result.any? nil).to be false
    expect(result.any? Numeric).to be true
  end

  it "Send an array which contains things other than numbers" do
    result = Montecasting::Forecasting.takt_times ["34",nil,"names"],1000
    expect(result).to be_nil
  end

  it "Send an array of cycle time and returns an array containing data for a takt times chart" do
    result = Montecasting::Charts.chart_takt_times(ct_values)
    expect(result.size).to be 3
    expect(result[0].first[:y]).to be_between(1,10)
    expect(result[0].last[:y]).to be_between(1,40)
    expect(result[2].last[:y]).to be > 90
  end

  it "Send an array of cycle times and returns an array containing data for a montecarlo chart" do
    result = Montecasting::Charts.chart_montecarlo(ct_values,200,5)
    expect(result[0].first[:y]).to be_between(400,600)
    expect(result[1].last[:y]).to be < 50
    expect(result[2].last[:y]).to be > 90
  end


end
