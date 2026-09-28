import 'package:flutter/foundation.dart';

import '../../../data/app_exeption.dart';
import '../../../data/response/api_response.dart';
import '../../weather_repository/weather_repository.dart';
import '../model/search_model.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._repository);

  final WeatherRepository _repository;

  // The screen starts idle. Loading begins only after Get Weather is tapped.
  ApiResponse<List<CityLocation>> cityResponse = const ApiResponse.completed(
    <CityLocation>[],
  );

  Future<void> searchCity(String city, String countryCode) async {
    cityResponse = const ApiResponse.loading();
    notifyListeners();

    try {
      final cities = await _repository.searchCities(city, countryCode);
      cityResponse = ApiResponse.completed(cities);
    } catch (error) {
      cityResponse = ApiResponse.error(_message(error));
    }

    notifyListeners();
  }

  void clearCitySearch() {
    cityResponse = const ApiResponse.completed(<CityLocation>[]);
    notifyListeners();
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'Something went wrong. Please try again.';
}
