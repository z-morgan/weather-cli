[![Tests](https://github.com/z-morgan/weather-cli/actions/workflows/tests.yml/badge.svg)](https://github.com/z-morgan/weather-cli/actions/workflows/tests.yml)

# Project 1: Weather Data Processor
## Objective: Create a command-line application that processes and displays weather data.
## Instructions:
1.	Data Generation: The application should generate random weather data for different cities. Each data point should include temperature, humidity, and wind speed.
2.	Object-Oriented Design: Implement classes and/or modules to represent different aspects of the weather data (e.g., City, WeatherReport).
3.	Configuration: Use a YAML file to configure the list of cities and any other parameters (like the range of possible temperature values).
4.	Output: The processed data should be displayed in JSON format on the console.
5.	Interactivity: Allow the user to specify a city and date range for which they want to see the weather report.
6.	Documentation: Write clear comments and documentation for your code.
## Evaluation Criteria:
•	Code organization and style.
•	Use of object-oriented principles.
•	Handling of external configuration.
•	Clarity of documentation and comments.

# Documentation

## Getting started:
```sh
# clone this repo
git clone https://github.com/z-morgan/weather-cli.git
cd weather-cli
bundle install

# run the app
ruby app.rb

# run the tests
rake test
```

## How it works:
The app generates weather data using parameters listed in a `weather_conf.yml` file. As soon as data generation is complete, the app will ask which city the user wants a weather report for.
```
Generating weather data... done.
Enter the city name:
> Portland
```
The city name is the only identifier for a city that `weather-cli` uses, so additional information must be added to the name to delineate between cities with the same name (i.e. `'Portland - OR'`). The app tolerates spaces and dashes in city names. 

Next, the app will allow the user to enter a set of timestamps delimiting the period over which the weather report should cover. The start and end timestamps are inclusive, meaning that if a data point exists with the same timestamp (down to the second) as either the start or end timestamp, that data poind will be included in the report.
```
Weather data for Portland is available for 2023-01-17 16:26:34 through 2024-01-17 15:26:34.
When should the weather report begin?
Enter a timestamp in 'YYYY-MM-DD hh:mm:ss' format:
> 2023-01-17 16:26:34
When should the weather report end?
Enter a timestamp in 'YYYY-MM-DD hh:mm:ss' format:
> 2024-01-17 15:26:34
```
Note that in this example, the start and end timestamps entered by the user are the same as the timestamps representing the limits of the dataset. This means that the report will contain all of the data points that are available for the city of Portland.
```
Generating weather report... done.
{
  "city": "Portland",
  "start_time": "2023-01-17 16:26:34",
  "end_time": "2024-01-17 16:26:34",
  "data_points": [
    {
      "timestamp": "2023-01-17 16:26:34",
      "tempurature": 11,
      "humidity": 61,
      "windSpeed": 25
    },

    ...

    {
      "timestamp": "2024-01-17 15:26:34",
      "tempurature": 100,
      "humidity": 88,
      "windSpeed": 64
    }
  ]
}
```
Finally, the app will give the user the chance to generate another report. Answering [y]es will allow them to select a new city and report period.
```
Would you like to generate another report? (y/n):
> n
```

## Configuration
The app uses a `weather_conf.yml` file in the root directory to configure the data that they app will generate. The following fields are required:
- `cities` - an array of strings setting the cities for which weather data will be generated.
- `data_bounds` - a hash of data point attributes which configures the minimum and maximum numeric values that each attribute can have.
- `seconds_since_data_start` - an integer specifying how far back data should be generated from the time that the app is initialized.

Here is an example `weather_conf.yml`:
```yaml
cities: 
  - 'Portland'
  - 'Chicago'
  - 'San Francisco'

data_bounds:
  temperature:
    min: -10
    max: 105
  humidity:
    min: 0
    max: 100
  wind_speed:
    min: 0
    max: 100

seconds_since_data_start: 31536000 # 1 year
```

# Design Decisions

1. Weather data is generated when the app is initialized, not when a report is requested. This mimics an app with a persistent data store, where weather data is collected in real time and already exists when the user runs the app.
2. Data points are generated with an hourly interval. This is typical for consumer weather apps, and also provides better performance and a smaller memory footprint for large time windows.
3. All of the timestamps in the app use the user's system timezone. This was purely for simplicity.

In the interest of time, some tradeoffs were made in the design. The app would benefit from addition of the following items:

1. packaging and distribution (perhaps as a gem which adds an executable to the users PATH)
2. validation of configuration details
3. a configuration option for pretty JSON or compact JSON
4. customized error messages based on why the user input is invalid
5. an algorithm to make weather data make sense based on location and time of day
6. an algorithm to guess and suggest the intended city when a user enters an invalid city name
