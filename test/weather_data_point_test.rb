require 'minitest/autorun'
require_relative '../lib/weather_data_point'

class WeatherDataPointTest < Minitest::Test
  def test_attrs_are_read_only
    data_point = WeatherDataPoint.new(Time.now, 50, 50, 5)
    assert_equal(data_point.temperature, 50)
    assert_raises(NoMethodError) { data_point.temperature = 25 }
  end
end