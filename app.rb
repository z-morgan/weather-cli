require_relative 'lib/weather_data_generator'
require_relative 'lib/weather_app'

CONFIG_FILE_NAME = 'weather_conf'

print 'Generating weather data... '

cities_weather_data = WeatherDataGenerator.new(CONFIG_FILE_NAME).generate_all_cities

puts 'done.'

WeatherApp.new(cities_weather_data).run