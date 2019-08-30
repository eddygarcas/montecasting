require 'time'
RSpec.describe Montecasting do

  array_of_cycle_times = [0.1, 0.1, 0.1, 0.1, 0.1, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3,15,16,26,50]
  variance_array = [1,1,1,1,0,1,1,2,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

  it "has a version number" do
    expect(Montecasting::VERSION).not_to be nil
  end

  it "returns data to build a cycle time chart" do
    result = Montecasting::Charts.chart_cycle_time(array_of_cycle_times,0)
    expect(result).not_to be nil
  end

  it "returns nil if the array contains something other than numerics" do
    result = Montecasting::Charts.chart_cycle_time([0.1, 0.1, 0.1, '0.2', 0.13454],0)
    expect(result).to be nil
  end

  it "Calculates the variance that shouold be 2.43 for the array given" do
    result = Montecasting::Metrics.variance variance_array
    expect(result.round(2)).to be 2.43
  end

  it "WIP limit for a given array of items" do
    result = Montecasting::Metrics.wip_limit array_of_cycle_times, (DateTime.now - 60),  DateTime.now
    pp result
  end

  it "Calculate the throughput" do
    result = Montecasting::Metrics.throughput array_of_cycle_times.count,  (DateTime.now - 60),  DateTime.now
    pp result
  end
end
