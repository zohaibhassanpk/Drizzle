import 'package:drizzle/data/Network/base_apiservice.dart';
import 'package:drizzle/data/Network/network_apiservice.dart';
import 'package:drizzle/data/app_exeption.dart';
import 'package:drizzle/features/forecast_screen/model/forecastmodel.dart';
import 'package:drizzle/features/search_screen/model/search_model.dart';
import 'package:drizzle/features/weather_screen.dart/model/currentweathermodel.dart';
import 'package:drizzle/resources/base_urls.dart';

class WeatherRepository {
  WeatherRepository({
    required this.apiKey,
    Baseapiservice? apiService,
  }) : _apiService =
            apiService ?? NetworkApiService();

  final String apiKey;
  final Baseapiservice _apiService;

  Future<List<CityLocation>> searchCities(
    String city,
    String countryCode,
  ) async {
    if (city.trim().isEmpty ||
        countryCode.trim().isEmpty) {
      throw const AppException(
        'Enter a city and select a country.',
      );
    }

    final url = _url(
      AppUrls.geoEndPoint,
      {
        'q':
            '${city.trim()},${countryCode.trim().toUpperCase()}',
        'limit': '5',
      },
    );

    final response =
        await _apiService.getResponse(url);

    if (response is! List) {
      throw const AppException(
        'Unexpected city search response.',
      );
    }

    return response
        .map(
          (city) => CityLocation.fromJson(
            city as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<CurrentWeather> getCurrentWeather(
    double lat,
    double lon,
  ) async {
    final url = _url(
      AppUrls.currentWeatherEndPoint,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'units': 'metric',
      },
    );

    final response =
        await _apiService.getResponse(url);

    if (response is! Map<String, dynamic>) {
      throw const AppException(
        'Unexpected current weather response.',
      );
    }

    return CurrentWeather.fromJson(response);
  }

  Future<ForecastModel> getForecast(
    double lat,
    double lon,
  ) async {
    final url = _url(
      AppUrls.forecastEndPoint,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'units': 'metric',
      },
    );

    final response =
        await _apiService.getResponse(url);

    if (response is! Map<String, dynamic>) {
      throw const AppException(
        'Unexpected forecast response.',
      );
    }

    return ForecastModel.fromJson(response);
  }

  String _url(
    String endpoint,
    Map<String, String> parameters,
  ) {
    if (apiKey.trim().isEmpty) {
      throw const AppException(
        'OpenWeather API key is missing.',
      );
    }

    return Uri.parse(endpoint)
        .replace(
          queryParameters: {
            ...parameters,
            'appid': apiKey,
          },
        )
        .toString();
  }
}