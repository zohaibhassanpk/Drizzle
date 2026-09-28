class CityLocation {
  String? name;
  Map<String, dynamic>? localNames;
  double? lat;
  double? lon;
  String? country;
  String? state;

  CityLocation({
    this.name,
    this.localNames,
    this.lat,
    this.lon,
    this.country,
    this.state,
  });

  CityLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    localNames = json['local_names'];

    lat = (json['lat'] as num?)?.toDouble();
    lon = (json['lon'] as num?)?.toDouble();

    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['name'] = name;
    data['local_names'] = localNames;
    data['lat'] = lat;
    data['lon'] = lon;
    data['country'] = country;
    data['state'] = state;

    return data;
  }
}

/// The city and country selected on the search screen.
class SearchRequest {
  const SearchRequest({
    required this.city,
    required this.countryCode,
    required this.countryName,
  });

  final String city;
  final String countryCode;
  final String countryName;
}

/// Location information needed by the current-weather screen.
class WeatherRequest {
  const WeatherRequest({
    required this.location,
    required this.countryName,
  });

  final CityLocation location;
  final String countryName;
}
