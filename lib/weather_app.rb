class WeatherApp
  def initialize(cities)
    @cities = cities
  end

  def run
    loop do
      city_name = get_city_name
      period = get_data_period(city_name)

      generate_weather_report(city_name, period)
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

=begin
find the starting data point (use BS)
scan from the starting data point to the last datapoint before the end timestamp
print that in JSON format

A: O(N)-O(log N) time, 
given a city weather_data array
- get the index of the first data point (bs helper)
- create a new array for the weather data points that are in the period
- iterate from that index up to the last index, and for each:
  - if the current timestamp is less than the end timestamp, add the data point new array
    else break

- create a WeatherReport object with the array of data points, the period, and the city name
- print that object in JSON format
=end

  def generate_weather_report(city_name, period)
    print 'Generating weather report... '

    first_dp_idx = find_first_dp_index(city_name, period[:start])

    puts 'done.'


  end

  # binary search to find the index of the first data point in the weather report
  def find_first_dp_index(city_name, start_timestamp)
    data_points = @cities[city_name].weather_data

    left = 0
    right = data_points.size - 1
    middle = nil
    while left <= right do
      middle = left + ((right - left) / 2)

      return 0 if middle == 0

      middle_dp_timestamp = data_points[middle].timestamp
      pre_middle_dp_timestamp = data_points[middle - 1].timestamp

      # move right if middle data_point is before start_timestamp
      if middle_dp_timestamp < start_timestamp
        left = middle + 1

      # move left if preceeding data_point is also after start_timestamp
      elsif pre_middle_dp_timestamp > start_timestamp
        right = middle - 1
      else
        break
      end
    end

    return middle
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