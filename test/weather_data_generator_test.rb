require 'minitest/autorun'
require_relative '../lib/weather_data_generator'

class WeatherDataGeneratorTest < Minitest::Test
  TEST_CONFIG_FILE_NAME = 'test/test_conf'

  def test_loads_config_file
    generator = WeatherDataGenerator.new(TEST_CONFIG_FILE_NAME)
    assert_equal(generator.city_names.first, 'Bend')
  end

  def test_generate_all_cities
    generator = WeatherDataGenerator.new(TEST_CONFIG_FILE_NAME)
    cities_weather_data = generator.generate_all_cities
    
    assert_includes(cities_weather_data.keys, 'Bend', 'Corvallis')

    assert_instance_of(City, cities_weather_data['Bend'])
    assert_equal(cities_weather_data['Bend'].name, 'Bend')

    # each city has 1 year's worth of hourly data points
    assert_equal(cities_weather_data['Bend'].weather_data.size, 24 * 365)
  end
end