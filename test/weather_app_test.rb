require 'minitest/autorun'
require 'stringio'
require_relative '../lib/weather_app'

class WeatherAppTest < Minitest::Test
  def setup
    weather_data = [
      WeatherDataPoint.new(Time.new(2024, 01, 17, 00, 40, 19), 15, 68, 32),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 01, 40, 19), 22, 48, 90),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 02, 40, 19), 12, 55, 20),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 03, 40, 19), -2, 96, 87),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 04, 40, 19), -6, 70, 16)
    ]

    bend = City.new('Bend')
    weather_data.each do |data_point|
      bend.add_weather_data_point(data_point)
    end

    cities = {'Bend' => bend}
    @app = WeatherApp.new(cities)
  end

  def test_generates_report
    user = StringIO.new
    user.puts ' bend '
    user.puts '2024-01-17 00:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    assert_match('Enter the city name:', app_output)
    assert_match('Generating weather report... done.', app_output)
    # the report was printed
    assert_match(/\{.+data_points.+humidity.+68/m, app_output)
  end

  def test_invalid_city_name
    user = StringIO.new
    user.puts 'Be nd'
    user.puts 'Bend'
    user.puts '2024-01-17 00:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # city prompt occurs again after city error message
    assert_match(/cities mentioned.+Enter the city name/m, app_output)
  end

  def test_start_time_too_early
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 00:40:18'
    user.puts '2024-01-17 00:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # start time prompt occurs again after start time error message
    assert_match(/timestamp within.+weather report begin\?/m, app_output)
  end

  def test_start_time_too_late
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 04:40:20'
    user.puts '2024-01-17 04:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # start time prompt occurs again after start time error message
    assert_match(/timestamp within.+weather report begin\?/m, app_output)
  end

  def test_end_time_before_start_time
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 04:40:19'
    user.puts '2024-01-17 04:40:18'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # end time prompt occurs again after end time error message
    assert_match(/timestamp between.+weather report end\?/m, app_output)
  end

  def test_end_time_too_late
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 04:40:19'
    user.puts '2024-01-17 04:40:20'
    user.puts '2024-01-17 04:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # end time prompt occurs again after end time error message
    assert_match(/timestamp between.+weather report end\?/m, app_output)
  end

  def test_invalid_run_again_response
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 00:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'heck yeah!'
    user.puts ' no '
    user.rewind

    app_output = run_app_with(user)

    # the report was printed
    assert_match(/\{.+data_points.+humidity.+68/m, app_output)
    # run again prompt occurs again after run again error message
    assert_match(/\[y\]es or \[n\]o\..+report\? \(y\/n\)/m, app_output)
  end

  def test_generates_two_reports
    user = StringIO.new
    user.puts 'Bend'
    user.puts '2024-01-17 03:40:19'
    user.puts '2024-01-17 04:40:19'
    user.puts 'y'
    user.puts 'Bend'
    user.puts '2024-01-17 00:40:19'
    user.puts '2024-01-17 02:40:19'
    user.puts 'n'
    user.rewind

    app_output = run_app_with(user)

    # the both reports were printed (humidity values reversed from data set)
    assert_match(/humidity.+70.+humidity.+68/m, app_output)
  end

  private

  def run_app_with(user)
    $stdin = user
    $stdout = StringIO.new

    @app.run
    app_output = $stdout.string

    $stdin = STDIN
    $stdout = STDOUT

    app_output
  end
end