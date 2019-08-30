require "montecasting/version"

module Montecasting

  def velocity_variance average_closed_points, by_sprint = []
    variance = 0
    by_sprint.each {|spt|
      variance += ((average_closed_points - spt.to_i) ** 2)
    }
    Math.sqrt(variance).round(0)
  end


  class Numeric
    def percent_of(n)
      percnt = self.to_f / n.to_f * 100.0
      percnt.nan? ? 0 : percnt
    end

    def number_of(n)
      nmbof = (self.to_f * n.to_f) / 100.0
      nmbof.nan? ? 0 : nmbof
    end
  end

  class Time
    def remaining toDate
      return 'n/d' if toDate.blank?
      intervals = [["d", 1], ["h", 24], ["m", 60]]
      elapsed = toDate.to_datetime - self.to_datetime
      interval = 1.0
      parts = intervals.collect do |name, new_interval|
        interval /= new_interval
        number, elapsed = elapsed.abs.divmod(interval)
        "#{number.to_i}#{name}" unless number.to_i == 0
      end
      "#{parts.join}"
    end
  end
end
