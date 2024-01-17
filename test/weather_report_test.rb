require 'minitest/autorun'
require_relative '../lib/weather_report'

class WeatherReportTest < Minitest::Test
  def setup
    @weather_data = [
      WeatherDataPoint.new(Time.new(2024, 01, 17, 00, 40, 19), 15, 68, 32),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 01, 40, 19), 22, 48, 90),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 02, 40, 19), 12, 55, 20),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 03, 40, 19), -2, 96, 87),
      WeatherDataPoint.new(Time.new(2024, 01, 17, 04, 40, 19), -6, 70, 16)
    ]
  end

  def test_has_data_points_for_odd_data_set
    period = { 
      start: Time.new(2024, 01, 17, 01, 40, 18),
      end: Time.new(2024, 01, 17, 04, 40, 18)
    }
    report = WeatherReport.new('Bend', period, @weather_data)

    assert_equal(3, report.data_points.size)
    assert_equal(1, report.data_points.first.timestamp.hour)
    assert_equal(3, report.data_points.last.timestamp.hour)
  end

  def test_has_data_points_for_even_data_set
    period = { 
      start: Time.new(2024, 01, 17, 01, 40, 18),
      end: Time.new(2024, 01, 17, 04, 40, 18)
    }
    report = WeatherReport.new('Bend', period, @weather_data[0...-1])

    assert_equal(3, report.data_points.size)
    assert_equal(1, report.data_points.first.timestamp.hour)
    assert_equal(3, report.data_points.last.timestamp.hour)
  end

  def test_first_data_point_is_first_in_data_set
    period = { 
      start: Time.new(2024, 01, 17, 00, 40, 19),
      end: Time.new(2024, 01, 17, 00, 40, 19)
    }
    report = WeatherReport.new('Bend', period, @weather_data)

    assert_equal(1, report.data_points.size)
    assert_equal(0, report.data_points.first.timestamp.hour)
  end

  def test_first_data_point_is_last_in_data_set
    period = { 
      start: Time.new(2024, 01, 17, 04, 40, 19),
      end: Time.new(2024, 01, 17, 04, 40, 19)
    }
    report = WeatherReport.new('Bend', period, @weather_data)

    assert_equal(1, report.data_points.size)
    assert_equal(4, report.data_points.first.timestamp.hour)
  end

  def test_last_data_point_is_after_end_of_data_set
    period = { 
      start: Time.new(2024, 01, 17, 02, 40, 19),
      end: Time.new(2024, 01, 17, 05, 40, 19)
    }
    report = WeatherReport.new('Bend', period, @weather_data)

    assert_equal(3, report.data_points.size)
    assert_equal(2, report.data_points.first.timestamp.hour)
  end
end