import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['WEATHER_API_KEY'];

class WeatherApi {
  final String _endpoint = 'https://api.weatherapi.com/v1';

  final Dio dio;

  WeatherApi(this.dio);

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    try {
      final response = await dio.get(
        '$_endpoint/current.json',
        queryParameters: {
          'key': apiKey,
          'q': city,
        },
      );
      return response.data;
    } catch (e) {
      print('Error fetching weather: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchForecastWeather(String city) async {
    try {
      final response = await dio.get(
        '$_endpoint/forecast.json',
        queryParameters: {
          'key': apiKey,
          'q': city,
          'days': 14,
          'hour': DateTime.now().hour,
        },
      );
      return response.data;
    } catch (e) {
      print('Error fetching weather: $e');
      return {};
    }
  }

  // search cities
  Future<Response> searchCities(String query) async {
    try {
      final response = await dio.get(
        'https://api.weatherapi.com/v1/search.json',
        queryParameters: {
          'key': apiKey,
          'q': query,
        },
      );
      return response;
    } catch (e) {
      print('Error searching cities: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      final getIp = await dio.get('http://ip-api.com/json/');

      final response = await dio.get(
        'https://api.weatherapi.com/v1/search.json',
        queryParameters: {
          'key': apiKey,
          'q': getIp.data['query'],
        },
      );
      return response.data[0];
    } catch (e) {
      print('Error fetching weather: $e');
      return {};
    }
  }
}
