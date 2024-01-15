require_relative 'lib/weather_data_generator'

CONFIG_FILE_NAME = 'weather_conf'

cities_weather_data = WeatherDataGenerator.new(CONFIG_FILE_NAME).generate_all_cities
p cities_weather_data["Portland"]