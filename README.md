[![Gem Version](https://badge.fury.io/rb/montecasting.svg)](https://badge.fury.io/rb/montecasting)
![Travis](https://travis-ci.org/eddygarcas/montecasting.svg?branch=master)

# Montecasting

Montecasting will provide a set of forecasting techniques to be used on software project management or product development. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'montecasting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install montecasting

## Usage
#### Metrics

    Montecasting::Metrics.variance(array_of_time = []) → int or nil

    Montecasting::Metrics.wip_limit(array_of_time = [], start_date, end_date) → int or nil
    
    Montecasting::Metrics.thoughtput(number_or_items, start_date, end_date) → int or nil
    
    Montecasting::Metrics.week_days(start_date, end_date) → new_ary 
        
#### Forecasting

    Montecasting::Forecasting.takt_times(cycle_time = [], rand_generator = 1000) → new_ary or nil

    Montecasting::Forecasting.montecarlo(takt_times = [], backlog_items = 0, days_iteration = 0) → new_ary or nil

#### Charts

    Montecasting::Charts.chart_takt_times(array_of_times = []) → [[{:x=> X,:y=> Y}]] on nil
    
    Montecasting::Charts.chart_montecarlo(array_of_times = [], backlog_items = 0, days_iteration = 0) → [[{:x=> X,:y=> Y}]] on nil
    
    Montecasting::Charts.chart_cycle_time(array_of_time = [], round_to = 0.5) → [[{:x=> X,:y=> Y}]] on nil
    
As a result of calling any method from Charts class, the message retrieved will have the following format

    [[{:x=>0, :y=>0},
        {:x=>1, :y=>1},
        ...
        {:x=>15, :y=>15}],
       [{:x=>0, :y=>5},
        ...
        {:x=>15, :y=>1}],
       [{:x=>0, :y=>0.0},
        ...
        {:x=>15, :y=>97.3}]]

So far, this format has been tested using rickshaw JavaScript toolkit for creating interactive real-time graphs.
Checkout https://github.com/shutterstock/rickshaw for more information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/montecasting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Montecasting project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/montecasting/blob/master/CODE_OF_CONDUCT.md).
