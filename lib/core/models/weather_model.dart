class WeatherModel {
  final String cityName;
  final DateTime date;
  final double tempC;
  final double windSpeed;
  final int humidity;
  final String conditionText;
  final String conditionIcon;

  WeatherModel({
    required this.cityName,
    required this.date,
    required this.tempC,
    required this.windSpeed,
    required this.humidity,
    this.conditionText = '',
    this.conditionIcon = '',
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      date: DateTime.parse(json['location']['localtime']),
      tempC: json['current']['temp_c'],
      windSpeed: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      conditionText: json['current']['condition']['text'],
      conditionIcon: "https:" + json['current']['condition']['icon'],
    );
  }

  factory WeatherModel.fromForecastJson(
      String cityName, Map<String, dynamic> forecastJson) {
    return WeatherModel(
      cityName: cityName,
      date: DateTime.parse(forecastJson['time']),
      tempC: forecastJson['temp_c'],
      windSpeed: forecastJson['wind_kph'],
      humidity: forecastJson['humidity'],
      conditionText: forecastJson['condition']['text'],
      conditionIcon: "https:" + forecastJson['condition']['icon'],
    );
  }

  static WeatherModel empty() {
    return WeatherModel(
      cityName: '',
      date: DateTime.now(),
      tempC: 0,
      windSpeed: 0,
      humidity: 0,
    );
  }
}
