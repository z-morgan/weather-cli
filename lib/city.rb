class City
  attr_reader :name
  attr_accessor :weather_data

  def initialize(name)
    @name = name
    @weather_data = {}
  end
end