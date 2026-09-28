class AppStrings {
  AppStrings._();

  static const String appName = 'Drizzle';
  static const String splashSubtitle = 'Simple Weather App';

  static const String findWeather = 'Find Weather';
  static const String selectCountryAndCity = 'Select your country and city';
  static const String country = 'Country';
  static const String city = 'City';
  static const String selectCountry = 'Select country';
  static const String searchCity = 'Search city';
  static const String getWeather = 'Get Weather';
  static const String useCurrentLocation = 'Use Current Location';
  static const String gettingLocation = 'Getting location...';
  static const String locationServicesDisabled =
      'Please turn on your device location and try again.';
  static const String locationPermissionDenied =
      'Location permission was denied.';
  static const String locationPermissionDeniedForever =
      'Location permission is blocked. Enable it from the app settings.';
  static const String locationUnavailable =
      'Could not get your current location. Please try again.';
  static const String locationTimedOut =
      'Getting your location took too long. Please try again.';
  static const String selectCountryFirst = 'Select a country first';
  static const String searchingCities = 'Searching cities...';
  static const String citySearchComplete = 'City search completed.';
  static const String gettingWeather = 'Getting weather...';
  static const String pleaseWait = 'Please wait';
  static const String cityNotFoundTitle = 'City not found';
  static const String cityNotFoundMessage =
      'Please check the city and country and try again.';
  static const String tryAgain = 'Try Again';
  static const String humidity = 'Humidity';
  static const String windSpeed = 'Wind Speed';
  static const String pressure = 'Pressure';
  static const String visibility = 'Visibility';
  static const String minimumTemperature = 'Minimum Temperature';
  static const String maximumTemperature = 'Maximum Temperature';
  static const String cloudiness = 'Cloudiness';
  static const String windDirection = 'Wind Direction';
  static const String sunrise = 'Sunrise';
  static const String sunset = 'Sunset';
  static const String fiveDayForecast = '5-Day Forecast';
  static const String weatherLoadError = 'Could not load the weather.';
  static const String next24Hours = 'Next 24 hours';
  static const String everyThreeHours = 'Every 3 hours';
  static const String lowHigh = 'Low · High';
  static const String now = 'Now';
  static const String gettingForecast = 'Getting forecast...';
  static const String forecastLoadError = 'Could not load the forecast.';
  static const String noRainExpected =
      'No heavy rain is expected during the next five days.';

  static String searchingIn(String country) => 'Searching in $country';
  static String feelsLike(String temperature) => 'Feels like $temperature';
  static String rainTip(String day, int chance) =>
      'Rain likely $day ($chance%). Carry an umbrella if you head out.';
}
