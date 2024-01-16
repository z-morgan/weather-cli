class WeatherApp
  def initialize(cities)
    @cities = cities
  end

  def run
    loop do
      city       = get_city_name
      # start_time = get_start_timestamp
      # end_time   = get_end_timestamp

      # generate_weather_report(city, start_time, end_time)
      break unless run_again?
    end
  end

  private

  def get_city_name
    city_prompt = 'Enter the city name:'
    invalid_city_msg = 'Only the cities mentioned in the config file are valid.'

    prompt_user(city_prompt, invalid_city_msg) do |response|
      # 'pOrTlAnD' and ' Portland ' are valid responses
      @cities.keys.any? { |key| key.downcase == response.downcase.strip }
    end
  end

  # requires a block which validates the user's response
  def prompt_user(prompt_msg, error_msg, &valid_response)
    response = nil

    loop do
      print "#{prompt_msg}\n> "
      response = gets.chomp
      
      break if valid_response.call(response) 
      puts 'That was not a valid response. ' + error_msg
    end

    response
  end

  def run_again?
    again_prompt = 'Would you like to generate another report? (y/n):'
    invalid_again_msg = 'That was not a valid response. Please type [y]es or [n]o.'

    choice = prompt_user(again_prompt, invalid_again_msg) do |response|
      # 'y', 'Y', 'yes', etc. are valid responses
      ['y', 'n'].include? response.downcase.strip[0]
    end

    choice == 'y'
  end
end