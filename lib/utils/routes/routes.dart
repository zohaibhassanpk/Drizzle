import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../core/services/location_service.dart';
import '../../features/search_screen/model/search_model.dart';
import '../../features/search_screen/model_view/current_location_viewmodel.dart';
import '../../features/search_screen/model_view/search_viewmodel.dart';
import '../../features/search_screen/view/search_error_screen.dart';
import '../../features/search_screen/view/search_loading_screen.dart';
import '../../features/search_screen/view/search_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../../features/forecast_screen/view/forecast_screen.dart';
import '../../features/forecast_screen/viewmodel/forecast_viewmodel.dart';
import '../../features/weather_repository/weather_repository.dart';
import '../../features/weather_screen.dart/view/weather_screen.dart';
import '../../features/weather_screen.dart/view_model/current_weather_viewmodel.dart';
import 'routes_name.dart';

class AppRoutes {
  AppRoutes._();

  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splash: (_) => const SplashScreen(),
    RouteNames.search: (_) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            WeatherRepository(apiKey: dotenv.get('OPENWEATHER_API_KEY')),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentLocationViewModel(LocationService()),
        ),
      ],
      child: const SearchScreen(),
    ),
    RouteNames.searchLoading: (context) {
      final request = ModalRoute.of(context)!.settings.arguments! as SearchRequest;

      return ChangeNotifierProvider(
        create: (_) => SearchViewModel(
          WeatherRepository(apiKey: dotenv.get('OPENWEATHER_API_KEY')),
        ),
        child: SearchLoadingScreen(request: request),
      );
    },
    RouteNames.searchError: (context) {
      final message = ModalRoute.of(context)!.settings.arguments! as String;

      return SearchErrorScreen(message: message);
    },
    RouteNames.currentWeather: (context) {
      final request =
          ModalRoute.of(context)!.settings.arguments! as WeatherRequest;

      return ChangeNotifierProvider(
        create: (_) => CurrentWeatherViewModel(
          WeatherRepository(apiKey: dotenv.get('OPENWEATHER_API_KEY')),
        ),
        child: WeatherScreen(request: request),
      );
    },
    RouteNames.forecast: (context) {
      final request =
          ModalRoute.of(context)!.settings.arguments! as WeatherRequest;

      return ChangeNotifierProvider(
        create: (_) => ForecastViewModel(
          WeatherRepository(apiKey: dotenv.get('OPENWEATHER_API_KEY')),
        ),
        child: ForecastScreen(request: request),
      );
    },
  };
}
