require 'json'

class WeatherReport
  attr_reader :city_name, :period, :data_points

  def initialize(city_name, period, weather_data)
    @city_name = city_name
    @period = period
    @data_points = []
    collect_data_points(weather_data)
  end

  def to_s
    JSON.pretty_generate({
      city: @city_name,
      start_time: @period[:start].strftime('%F %T'),
      end_time: @period[:end].strftime('%F %T'),
      data_points: @data_points.map(&:to_hash)
    })
  end

  private

  def collect_data_points(weather_data)
    i = find_first_dp_index(@period[:start], weather_data)

    # collect the data points within the report period
    while i < weather_data.size do
      break if weather_data[i].timestamp.floor > (@period[:end])
      @data_points.push(weather_data[i])
      i += 1
    end
  end

  # binary search to find the index of the report's first data point
  def find_first_dp_index(start_timestamp, weather_data)
    left = 0
    right = weather_data.size - 1
    middle = nil
    while left <= right do
      middle = left + ((right - left) / 2)

      middle_dp_timestamp = weather_data[middle].timestamp

      # catches edge case where first dp_index is 0
      return 0 if middle == 0 && middle_dp_timestamp > start_timestamp
      pre_middle_dp_timestamp = weather_data[middle - 1].timestamp

      # move right if middle data_point is before start_timestamp
      if middle_dp_timestamp < start_timestamp
        left = middle + 1

      # move left if preceeding data_point is also after start_timestamp
      elsif pre_middle_dp_timestamp > start_timestamp
        right = middle - 1
      else
        break
      end
    end

    return middle
  end
end 