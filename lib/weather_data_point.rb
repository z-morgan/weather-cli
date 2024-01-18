require 'json'

class WeatherDataPoint
  attr_reader :timestamp, :temperature, :humidity, :wind_speed

  def initialize(timestamp, temperature, humidity, wind_speed)
    @timestamp   = timestamp
    @temperature = temperature
    @humidity    = humidity
    @wind_speed  = wind_speed
  end

  def to_hash
    {
      timestamp: @timestamp.strftime('%F %T'),
      tempurature: @temperature,
      humidity: @humidity,
      windSpeed: @wind_speed,
    }
  end
end