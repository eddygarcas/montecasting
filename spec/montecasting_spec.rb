RSpec.describe Montecasting do

  array_of_cycle_times = [0.1, 0.1, 0.1, 0.1, 0.1, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3,15,16,26,50]

  it "has a version number" do
    expect(Montecasting::VERSION).not_to be nil
  end

  it "returns data to build a cycle time chart" do
    result = Montecasting::Charts.chart_cycle_time(array_of_cycle_times,0)
    pp result
    expect(result).not_to be nil
  end

  it "returns nil if the array contains something other than numerics" do
    result = Montecasting::Charts.chart_cycle_time([0.1, 0.1, 0.1, '0.2', 0.13454, 0.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3],0)
    pp result
    expect(result).to be nil
  end
end
