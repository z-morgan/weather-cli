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
    response = nil
    loop do
      prompt 'Enter the city name:'
      response = gets.chomp
      
      # 'pOrTlAnD' and ' Portland ' are valid responses
      response = response.downcase.strip

      break if @cities.keys.any? { |k| k.downcase == response }
      puts 'That was not a valid response. Only the cities mentioned in the config file are valid.'
    end
    response
  end

  def run_again?
    response = nil
    loop do
      prompt 'Would you like to generate another report? (y/n):'
      response = gets.chomp

      # 'y', 'Y', 'yes', etc. are valid responses
      response = response.downcase.strip[0]

      break if ['y', 'n'].include? response
      puts 'That was not a valid response. Please type [y]es or [n]o.'
    end
    response == 'y'
  end

  def prompt(message)
    print "#{message}\n> "
  end
end