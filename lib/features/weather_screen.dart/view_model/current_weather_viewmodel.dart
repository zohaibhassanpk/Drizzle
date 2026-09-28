import 'package:flutter/foundation.dart';

import '../../../data/app_exeption.dart';
import '../../../data/response/api_response.dart';
import '../../weather_repository/weather_repository.dart';
import '../model/currentweathermodel.dart';

class CurrentWeatherViewModel extends ChangeNotifier {
  CurrentWeatherViewModel(this._repository);

  final WeatherRepository _repository;

  ApiResponse<CurrentWeather> weatherResponse = const ApiResponse.loading();

  Future<void> getCurrentWeather(double lat, double lon) async {
    weatherResponse = const ApiResponse.loading();
    notifyListeners();

    try {
      final weather = await _repository.getCurrentWeather(lat, lon);
      weatherResponse = ApiResponse.completed(weather);
    } catch (error) {
      weatherResponse = ApiResponse.error(_message(error));
    }

    notifyListeners();
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'Something went wrong. Please try again.';
}
