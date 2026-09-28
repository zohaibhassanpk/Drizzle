import 'package:drizzle/data/Network/base_apiservice.dart';
import 'package:drizzle/features/weather_repository/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('searchCity uses the geocoding URL', () async {
    final api = _FakeApiService([
      {'name': 'Islamabad', 'country': 'PK', 'lat': 33.7, 'lon': 73.1},
    ]);
    final repository = WeatherRepository(apiKey: 'test-key', apiService: api);

    final cities = await repository.searchCities('Islamabad', 'PK');

    expect(cities.single.name, 'Islamabad');
    final url = Uri.parse(api.url!);
    expect(url.path, '/geo/1.0/direct');
    expect(url.queryParameters['q'], 'Islamabad,PK');
    expect(url.queryParameters['limit'], '5');
  });

  test('getCurrentWeather uses the current weather URL', () async {
    final api = _FakeApiService({
      'coord': {'lat': 33.7, 'lon': 73.1},
      'weather': [
        {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
      ],
      'main': {
        'temp': 25.0,
        'feels_like': 25.5,
        'temp_min': 24.0,
        'temp_max': 26.0,
        'pressure': 1009,
        'humidity': 73,
      },
      'wind': {'speed': 2.0},
      'clouds': {'all': 0},
      'sys': {'country': 'PK'},
      'name': 'Islamabad',
      'cod': 200,
    });
    final repository = WeatherRepository(apiKey: 'test-key', apiService: api);

    final weather = await repository.getCurrentWeather(33.7, 73.1);

    expect(weather.name, 'Islamabad');
    final url = Uri.parse(api.url!);
    expect(url.path, '/data/2.5/weather');
    expect(url.queryParameters['lat'], '33.7');
    expect(url.queryParameters['lon'], '73.1');
    expect(url.queryParameters['units'], 'metric');
  });

  test('getForecast uses the forecast URL', () async {
    final api = _FakeApiService({
      'cod': '200',
      'cnt': 1,
      'list': [],
      'city': {'name': 'Islamabad', 'country': 'PK'},
    });
    final repository = WeatherRepository(apiKey: 'test-key', apiService: api);

    final forecast = await repository.getForecast(33.7, 73.1);

    expect(forecast.cod, '200');
    final url = Uri.parse(api.url!);
    expect(url.path, '/data/2.5/forecast');
    expect(url.queryParameters['lat'], '33.7');
    expect(url.queryParameters['lon'], '73.1');
    expect(url.queryParameters['units'], 'metric');
  });
}

class _FakeApiService extends Baseapiservice {
  _FakeApiService(this.response);

  final dynamic response;
  String? url;

  @override
  Future<dynamic> getResponse(String requestUrl) async {
    url = requestUrl;
    return response;
  }
}
