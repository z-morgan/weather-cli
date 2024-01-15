require 'minitest/autorun'
require_relative '../lib/city'
require_relative '../lib/weather_data_point'

class CityTest < Minitest::Test
  def test_add_weather_data_point
    city = City.new('Portland')
    data_point = WeatherDataPoint.new(Time.now, 50, 50, 5)
    city.add_weather_data_point(data_point)
    assert_equal(data_point, city.weather_data.first)
  end

  def test_weather_data_points_must_be_correct_data_type
    city = City.new('Portland')
    data_point = Hash.new
    assert_raises(TypeError) { city.add_weather_data_point(data_point) }
  end

  def test_weather_data_points_must_have_ascending_timestamps
    city = City.new('Portland')
    timestamp = Time.now
    city.add_weather_data_point(WeatherDataPoint.new(timestamp, 50, 50, 5))
    timestamp -= 1

    assert_raises(RuntimeError) do
      city.add_weather_data_point(WeatherDataPoint.new(timestamp, 50, 50, 5))
    end
  end
end