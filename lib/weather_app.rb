class WeatherApp
  def initialize(cities)
    @cities = cities
  end

  def run
    loop do
      city_name = get_city_name
      period = get_data_period(city_name)

      # generate_weather_report(city_name, period)
      break unless run_again?
    end
  end

  private

  def get_city_name
    city_prompt = 'Enter the city name:'
    invalid_city_msg = 'Only the cities mentioned in the config file are valid.'

    city_name = nil

    prompt_user(city_prompt, invalid_city_msg) do |response|
      city_name = @cities.keys.find do |key|
        # 'pOrTlAnD' and ' Portland ' are valid responses
        key.downcase == response.downcase.strip
      end
    end

    city_name
  end

  # requires a block which validates the user's response
  def prompt_user(prompt_msg, error_msg, &valid_response)
    response = nil

    loop do
      print "#{prompt_msg}\n> "
      response = gets.chomp
      
      break if valid_response.call(response) 
      puts 'INVALID RESPONSE: ' + error_msg
    end

    response
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

  def run_again?
    again_prompt = 'Would you like to generate another report? (y/n):'
    invalid_again_msg = 'Please type [y]es or [n]o.'

    choice = prompt_user(again_prompt, invalid_again_msg) do |response|
      # 'y', 'Y', 'yes', etc. are valid responses
      ['y', 'n'].include? response.downcase.strip[0]
    end

    choice == 'y'
  end

  def prompt(message)
    print "#{message}\n> "
  end
end