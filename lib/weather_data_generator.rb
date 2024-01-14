require 'yaml'

class WeatherDataGenerator
  def initialize(config_file)
    config = load_config_from(config_file)

    @city_names  = config['cities']
    @tempurature = config['data_bounds']['tempurature']
    @humidity    = config['data_bounds']['humidity']
    @wind_speed  = config['data_bounds']['wind_speed']
  end

  def generate_all_cities
    @city_names
  end

  private

  def load_config_from(file_name)
    config = nil
    extension = '.yml'

    # check for both '.yml' and '.yaml' extensions
    begin
      config = YAML.load_file(file_name + extension)

    rescue Errno::ENOENT
      if extension == '.yml'
        extension = '.yaml'
        retry

      else
        puts "Could not find config file. Make sure that it is named '#{file_name}.yml' or '#{file_name}.yaml'."
        exit 1
      end
    end
  end
end