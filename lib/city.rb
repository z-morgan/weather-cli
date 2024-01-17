require_relative 'weather_data_point'

class City
  attr_reader :name, :weather_data

  def initialize(name)
    @name = name
    @weather_data = []
  end

  def add_weather_data_point(data_point)
    if data_point.class != WeatherDataPoint
      raise TypeError, "City weather data can only be instances of class WeatherDataPoint."
    elsif (!@weather_data.empty? &&
          @weather_data.last.timestamp >= data_point.timestamp)
      raise RuntimeError, "Weather data points must be added with timestamps in ascending order."
    end

    @weather_data.push(data_point)
    data_point
  end

  def first
    @weather_data.first
  end

  def last
    @weather_data.last
  end
end