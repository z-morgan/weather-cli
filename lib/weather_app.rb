require_relative 'weather_report'

class WeatherApp
  def initialize(cities)
    @cities = cities
  end

  def run
    loop do
      city_name = get_city_name
      period = get_data_period(city_name)
      print_weather_report(city_name, period)
      break unless run_again?
    end
  end

  private

  def get_city_name
    city_name = nil
    loop do
      prompt 'Enter the city name:'
      response = gets.chomp

      city_name = @cities.keys.find do |key|
        # 'pOrTlAnD' and ' Portland ' are valid responses
        key.downcase == response.downcase.strip
      end
      
      break if city_name
      puts 'INVALID RESPONSE: Only the cities mentioned in the config file are valid.'
    end

    city_name
  end

  def get_data_period(city_name)
    min_timestamp = @cities[city_name].first.timestamp
    max_timestamp = @cities[city_name].last.timestamp
    
    puts "Weather data for #{city_name} is available for #{min_timestamp} through #{max_timestamp}."
    
    start_timestamp = nil
    loop do
      prompt "When should the weather report begin? \nEnter a timestamp in 'YYYY-MM-DD hh:mm:ss' format:"
      response = gets.chomp.strip
      start_timestamp = Time.new(*response.split(/[\- :]/).map(&:to_i))
      
      # Time#floor and Time#ceil cover edge case bugs due to different sub-second values
      break if start_timestamp >= min_timestamp.floor && start_timestamp <= max_timestamp.ceil
      puts 'INVALID RESPONSE: Please enter a timestamp within the period for which data is available.'
    end

    end_timestamp = nil
    loop do
      prompt "When should the weather report end? \nEnter a timestamp in 'YYYY-MM-DD hh:mm:ss' format:"
      response = gets.chomp.strip
      end_timestamp = Time.new(*response.split(/[\- :]/).map(&:to_i))
      
      # Time#floor and Time#ceil cover edge case bugs due to different sub-second values
      break if end_timestamp >= start_timestamp.floor && end_timestamp <= max_timestamp.ceil
      puts 'INVALID RESPONSE: Please enter a timestamp between the start timestamp and the end of the available data period.'
    end

    return { start: start_timestamp, end: end_timestamp }
  end

  def print_weather_report(city_name, period)
    weather_data = @cities[city_name].weather_data

    print 'Generating weather report... '
    report = WeatherReport.new(city_name, period, weather_data)
    puts 'done.'
    puts report
  end

  def run_again?
    choice = nil

    loop do
      prompt 'Would you like to generate another report? (y/n):'

      # 'y', 'Y', 'yes', etc. are valid responses
      choice = gets.chomp.downcase.strip[0]

      break if ['y', 'n'].include? choice
      puts 'INVALID RESPONSE: Please type [y]es or [n]o.'
    end

    choice == 'y'
  end

  def prompt(message)
    print "#{message}\n> "
  end
end