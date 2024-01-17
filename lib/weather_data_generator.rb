require 'yaml'

require_relative 'city'
require_relative 'weather_data_point'

class WeatherDataGenerator
  MAX_DATA_TIMESTAMP = Time.now
  ONE_HOUR_IN_SECONDS = 60 * 60

  attr_reader :city_names, :tempurature, :humidity, :wind_speed

  def initialize(config_file_name)
    config = load_config_from(config_file_name)

    @min_data_timestamp = MAX_DATA_TIMESTAMP - config['seconds_since_data_start']
    @city_names         = config['cities']
    @temperature        = config['data_bounds']['temperature']
    @humidity           = config['data_bounds']['humidity']
    @wind_speed         = config['data_bounds']['wind_speed']
  end

  def generate_all_cities
    cities_weather_data = {}

    @city_names.each do |city_name|
      city = City.new(city_name)

      timestamp = @min_data_timestamp
      while timestamp < MAX_DATA_TIMESTAMP do
        city.add_weather_data_point(generate_data_point(timestamp))
        timestamp += ONE_HOUR_IN_SECONDS
      end

      cities_weather_data[city_name] = city
    end

    cities_weather_data
  end

  private

  def load_config_from(file_name)
    config = nil
    extension = '.yml'

    # check for both '.yml' and '.yaml' file extensions
    begin
      config = YAML.load_file(file_name + extension)

    rescue Errno::ENOENT
      if extension == '.yml'
        extension = '.yaml'
        retry

      else
        puts "Could not find config file. Make sure that it is named "\
             "'#{file_name}.yml' or '#{file_name}.yaml'."
        exit 1
      end
    end

    config
  end

  def generate_data_point(timestamp)
    temperature = Random.rand(@temperature['min']..@temperature['max'])
    humidity    = Random.rand(@humidity['min']..@humidity['max'])
    wind_speed  = Random.rand(@wind_speed['min']..@wind_speed['max'])

    WeatherDataPoint.new(timestamp, temperature, humidity, wind_speed)
  end
end