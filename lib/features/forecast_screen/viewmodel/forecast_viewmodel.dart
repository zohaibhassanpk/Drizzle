import 'package:flutter/foundation.dart';

import '../../../data/app_exeption.dart';
import '../../../data/response/api_response.dart';
import '../../weather_repository/weather_repository.dart';
import '../model/forecastmodel.dart';

class ForecastViewModel extends ChangeNotifier {
  ForecastViewModel(this._repository);

  final WeatherRepository _repository;

  ApiResponse<ForecastModel> forecastResponse = const ApiResponse.loading();

  Future<void> getForecast(double lat, double lon) async {
    forecastResponse = const ApiResponse.loading();
    notifyListeners();

    try {
      final forecast = await _repository.getForecast(lat, lon);
      forecastResponse = ApiResponse.completed(forecast);
    } catch (error) {
      forecastResponse = ApiResponse.error(_message(error));
    }

    notifyListeners();
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'Something went wrong. Please try again.';
}
