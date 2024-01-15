class City
  attr_reader :name
  attr_accessor :weather_data

  def initialize(name)
    @name = name
    @weather_data = []
  end

  def add_weather_data_point(data_point)
    # check that data_point is of correct class here
    # check that data_point timestamp is greater than previous timestamp

    @weather_data.push(data_point)
    data_point
  end
end