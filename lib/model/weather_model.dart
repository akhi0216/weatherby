class WeatherModel {
  final String main;
  final double temp;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int precipitation;
  final int visibility;
  final List<HourlyWeather> hourly;
  final String country;

  WeatherModel({
    required this.main,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.precipitation,
    required this.visibility,
    required this.hourly,
    required this.country,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      main: json['weather'][0]['main'],
      temp: json['main']['temp'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      precipitation: json['pop'] != null ? (json['pop'] * 100).toInt() : 10,
      visibility: ((json['visibility'] ?? 10000) / 1000).round(),
      hourly: List.generate(5, (i) => HourlyWeather.mock(i)),
      country: json['sys'] != null && json['sys']['country'] != null ? json['sys']['country'].toString().toLowerCase() : 'us',
    );
  }
}

class HourlyWeather {
  final String hour;
  final int temp;
  final String iconUrl;

  HourlyWeather({required this.hour, required this.temp, required this.iconUrl});

  static HourlyWeather mock(int i) {
    final now = DateTime.now();
    return HourlyWeather(
      hour: "${(now.hour + i) % 24} ${((now.hour + i) % 24) < 12 ? 'AM' : 'PM'}",
      temp: 16 + i,
      iconUrl: 'https://i.imgur.com/jfKeT0H.png',
    );
  }
}
