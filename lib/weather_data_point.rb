require 'json'

class WeatherDataPoint
  attr_reader :timestamp, :temperature, :humidity, :wind_speed

  def initialize(timestamp, temperature, humidity, wind_speed)
    @timestamp   = timestamp
    @temperature = temperature
    @humidity    = humidity
    @wind_speed  = wind_speed
  end

  def to_s
    JSON.generate({
      'timestamp' => @timestamp,
      'temperature' => @temperature,
      'humidity' => @humidity,
      'windSpeed' => @wind_speed,
    })
  end
end