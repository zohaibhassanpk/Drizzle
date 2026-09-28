class AppUrls {
  static const String baseUrl =
      'https://api.openweathermap.org';

  // City search / Geocoding
  static const String geoEndPoint =
      '$baseUrl/geo/1.0/direct';

  // Current weather
  static const String currentWeatherEndPoint =
      '$baseUrl/data/2.5/weather';

  // 5 day / 3 hour forecast
  static const String forecastEndPoint =
      '$baseUrl/data/2.5/forecast';
}