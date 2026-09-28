class CurrentWeather {
  Coord? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  int? visibility;
  Wind? wind;
  Clouds? clouds;
  int? dt;
  Sys? sys;
  int? timezone;
  int? id;
  String? name;
  int? cod;

  CurrentWeather({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  CurrentWeather.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null
        ? Coord.fromJson(json['coord'])
        : null;

    if (json['weather'] != null) {
      weather = <Weather>[];

      json['weather'].forEach((v) {
        weather!.add(
          Weather.fromJson(v),
        );
      });
    }

    base = json['base'];

    main = json['main'] != null
        ? Main.fromJson(json['main'])
        : null;

    visibility =
        (json['visibility'] as num?)?.toInt();

    wind = json['wind'] != null
        ? Wind.fromJson(json['wind'])
        : null;

    clouds = json['clouds'] != null
        ? Clouds.fromJson(json['clouds'])
        : null;

    dt = (json['dt'] as num?)?.toInt();

    sys = json['sys'] != null
        ? Sys.fromJson(json['sys'])
        : null;

    timezone =
        (json['timezone'] as num?)?.toInt();

    id = (json['id'] as num?)?.toInt();

    name = json['name'];

    cod = (json['cod'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (coord != null) {
      data['coord'] = coord!.toJson();
    }

    if (weather != null) {
      data['weather'] =
          weather!.map((v) => v.toJson()).toList();
    }

    data['base'] = base;

    if (main != null) {
      data['main'] = main!.toJson();
    }

    data['visibility'] = visibility;

    if (wind != null) {
      data['wind'] = wind!.toJson();
    }

    if (clouds != null) {
      data['clouds'] = clouds!.toJson();
    }

    data['dt'] = dt;

    if (sys != null) {
      data['sys'] = sys!.toJson();
    }

    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;

    return data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({
    this.lon,
    this.lat,
  });

  Coord.fromJson(Map<String, dynamic> json) {
    lon = (json['lon'] as num?)?.toDouble();
    lat = (json['lat'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  Weather.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? humidity;
  int? seaLevel;
  int? grndLevel;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp =
        (json['temp'] as num?)?.toDouble();

    feelsLike =
        (json['feels_like'] as num?)?.toDouble();

    tempMin =
        (json['temp_min'] as num?)?.toDouble();

    tempMax =
        (json['temp_max'] as num?)?.toDouble();

    pressure =
        (json['pressure'] as num?)?.toInt();

    humidity =
        (json['humidity'] as num?)?.toInt();

    seaLevel =
        (json['sea_level'] as num?)?.toInt();

    grndLevel =
        (json['grnd_level'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'pressure': pressure,
      'humidity': humidity,
      'sea_level': seaLevel,
      'grnd_level': grndLevel,
    };
  }
}

class Wind {
  double? speed;
  int? deg;
  double? gust;

  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  Wind.fromJson(Map<String, dynamic> json) {
    speed =
        (json['speed'] as num?)?.toDouble();

    deg =
        (json['deg'] as num?)?.toInt();

    gust =
        (json['gust'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
      'gust': gust,
    };
  }
}

class Clouds {
  int? all;

  Clouds({
    this.all,
  });

  Clouds.fromJson(Map<String, dynamic> json) {
    all = (json['all'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
    };
  }
}

class Sys {
  String? country;
  int? sunrise;
  int? sunset;

  Sys({
    this.country,
    this.sunrise,
    this.sunset,
  });

  Sys.fromJson(Map<String, dynamic> json) {
    country = json['country'];

    sunrise =
        (json['sunrise'] as num?)?.toInt();

    sunset =
        (json['sunset'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}