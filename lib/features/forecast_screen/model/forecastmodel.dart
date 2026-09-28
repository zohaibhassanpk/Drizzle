class ForecastModel {
  String? cod;
  int? message;
  int? cnt;
  List<ForecastItem>? list;
  City? city;

  ForecastModel({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  ForecastModel.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    message = (json['message'] as num?)?.toInt();
    cnt = (json['cnt'] as num?)?.toInt();

    if (json['list'] != null) {
      list = <ForecastItem>[];

      json['list'].forEach((v) {
        list!.add(
          ForecastItem.fromJson(v),
        );
      });
    }

    city = json['city'] != null
        ? City.fromJson(json['city'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;

    if (list != null) {
      data['list'] =
          list!.map((v) => v.toJson()).toList();
    }

    if (city != null) {
      data['city'] = city!.toJson();
    }

    return data;
  }
}

class ForecastItem {
  int? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;
  Sys? sys;
  String? dtTxt;
  Rain? rain;

  ForecastItem({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dtTxt,
    this.rain,
  });

  ForecastItem.fromJson(Map<String, dynamic> json) {
    dt = (json['dt'] as num?)?.toInt();

    main = json['main'] != null
        ? Main.fromJson(json['main'])
        : null;

    if (json['weather'] != null) {
      weather = <Weather>[];

      json['weather'].forEach((v) {
        weather!.add(
          Weather.fromJson(v),
        );
      });
    }

    clouds = json['clouds'] != null
        ? Clouds.fromJson(json['clouds'])
        : null;

    wind = json['wind'] != null
        ? Wind.fromJson(json['wind'])
        : null;

    visibility =
        (json['visibility'] as num?)?.toInt();

    pop =
        (json['pop'] as num?)?.toDouble();

    sys = json['sys'] != null
        ? Sys.fromJson(json['sys'])
        : null;

    dtTxt = json['dt_txt'];

    rain = json['rain'] != null
        ? Rain.fromJson(json['rain'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['dt'] = dt;

    if (main != null) {
      data['main'] = main!.toJson();
    }

    if (weather != null) {
      data['weather'] =
          weather!.map((v) => v.toJson()).toList();
    }

    if (clouds != null) {
      data['clouds'] = clouds!.toJson();
    }

    if (wind != null) {
      data['wind'] = wind!.toJson();
    }

    data['visibility'] = visibility;
    data['pop'] = pop;

    if (sys != null) {
      data['sys'] = sys!.toJson();
    }

    data['dt_txt'] = dtTxt;

    if (rain != null) {
      data['rain'] = rain!.toJson();
    }

    return data;
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  double? tempKf;
  double? dewPoint;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
    this.dewPoint,
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

    seaLevel =
        (json['sea_level'] as num?)?.toInt();

    grndLevel =
        (json['grnd_level'] as num?)?.toInt();

    humidity =
        (json['humidity'] as num?)?.toInt();

    tempKf =
        (json['temp_kf'] as num?)?.toDouble();

    dewPoint =
        (json['dew_point'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['sea_level'] = seaLevel;
    data['grnd_level'] = grndLevel;
    data['humidity'] = humidity;
    data['temp_kf'] = tempKf;
    data['dew_point'] = dewPoint;

    return data;
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
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;

    return data;
  }
}

class Clouds {
  int? all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = (json['all'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
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

class Sys {
  String? pod;

  Sys({this.pod});

  Sys.fromJson(Map<String, dynamic> json) {
    pod = json['pod'];
  }

  Map<String, dynamic> toJson() {
    return {
      'pod': pod,
    };
  }
}

class Rain {
  double? d3h;

  Rain({this.d3h});

  Rain.fromJson(Map<String, dynamic> json) {
    d3h =
        (json['3h'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      '3h': d3h,
    };
  }
}

class City {
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  City.fromJson(Map<String, dynamic> json) {
    id =
        (json['id'] as num?)?.toInt();

    name = json['name'];

    coord = json['coord'] != null
        ? Coord.fromJson(json['coord'])
        : null;

    country = json['country'];

    population =
        (json['population'] as num?)?.toInt();

    timezone =
        (json['timezone'] as num?)?.toInt();

    sunrise =
        (json['sunrise'] as num?)?.toInt();

    sunset =
        (json['sunset'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;

    if (coord != null) {
      data['coord'] = coord!.toJson();
    }

    data['country'] = country;
    data['population'] = population;
    data['timezone'] = timezone;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;

    return data;
  }
}

class Coord {
  double? lat;
  double? lon;

  Coord({
    this.lat,
    this.lon,
  });

  Coord.fromJson(Map<String, dynamic> json) {
    lat =
        (json['lat'] as num?)?.toDouble();

    lon =
        (json['lon'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}