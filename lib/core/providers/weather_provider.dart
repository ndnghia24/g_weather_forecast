import 'package:flutter/material.dart';
import 'package:g_weather_forecast/core/api/mail_subscribe_api.dart';
import 'package:g_weather_forecast/core/api/weather_api.dart';
import 'package:g_weather_forecast/core/models/location_model.dart';
import 'package:g_weather_forecast/core/models/weather_model.dart';
import 'package:g_weather_forecast/core/storage/location_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApi weatherApi;
  final MailSubscribeApi mailSubscribeApi;

  LocationModel _city = LocationModel.empty();

  WeatherModel? _currentWeather;
  List<WeatherModel> _forecast = [];

  WeatherProvider(this.weatherApi, this.mailSubscribeApi) {
    _initializeCity();
  }

  LocationModel get city => _city;
  WeatherModel? get currentWeather => _currentWeather;
  List<WeatherModel> get forecast => _forecast;

  Future<void> _initializeCity() async {
    final store = MyLocalStore();
    final storedCityData = await store.getData('weather_city');

    if (storedCityData != null) {
      _city = LocationModel.fromJson(storedCityData);
      await fetchWeather();
    } else {
      notifyListeners();
    }
  }

  Future<void> setCity(LocationModel newCity) async {
    _city = newCity;
    await fetchWeather();
    final store = MyLocalStore();
    await store.saveData('weather_city', _city.toJson());

    notifyListeners();
  }

  Future<void> fetchWeather() async {
    try {
      final currentWeatherFuture = fetchCurrentWeather();
      final forecastWeatherFuture = fetchForecastWeather();

      _currentWeather = await currentWeatherFuture;
      notifyListeners();

      _forecast = await forecastWeatherFuture;
      notifyListeners();
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  Future<WeatherModel?> fetchCurrentWeather() async {
    try {
      final data = await weatherApi.fetchCurrentWeather(_city.name);
      return WeatherModel.fromJson(data);
    } catch (e) {
      print('Error fetching current weather: $e');
      return null;
    }
  }

  Future<List<WeatherModel>> fetchForecastWeather() async {
    try {
      final data = await weatherApi.fetchForecastWeather(_city.name);

      return (data['forecast']['forecastday'] as List)
          .map((dateWeather) {
            return WeatherModel.fromForecastJson(
              data['location']['name'],
              (dateWeather['hour'] as List).first,
            );
          })
          .skip(1)
          .toList();
    } catch (e) {
      print('Error fetching forecast weather: $e');
      return [];
    }
  }

  Future<List<LocationModel>> searchCities(String query) async {
    try {
      final response = await weatherApi.searchCities(query);

      return (response.data as List)
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error searching cities: $e');
      return [];
    }
  }

  // notify all subscriber
  Future<void> sendBulkEmails() async {
    try {
      final response = await mailSubscribeApi.sendBulkEmails();

      if (response.statusCode == 200) {
        print('Bulk emails sent successfully');
      } else {
        print('Bulk emails sending failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error subscribing email: $e');
    }
  }

  Future<void> subscribeEmail(String email) async {
    try {
      final response = await mailSubscribeApi.subscribe(email, _city.name);

      if (response.statusCode == 200) {
        print('Subscribed successfully for $email at ${_city.name}');
      } else {
        print('Subscription failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error subscribing email: $e');
    }
  }

  Future<void> unsubscribeEmail(String email) async {
    try {
      final response = await mailSubscribeApi.unsubscribe(email);

      if (response.statusCode == 200) {
        print('Unsubscribed successfully for $email');
      } else {
        print('Unsubscription failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error unsubscribing email: $e');
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final response = await mailSubscribeApi.resendVerification(email);

      if (response.statusCode == 200) {
        print('Verification email resent successfully for $email');
      } else {
        print('Resending verification email failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error resending verification email: $e');
    }
  }

  // get current location by IP
  Future<LocationModel> getCurrentLocation() async {
    try {
      final data = await weatherApi.getCurrentLocation();

      return LocationModel.fromJson(data);
    } catch (e) {
      print('Error getting current location: $e');
      return LocationModel.empty();
    }
  }
}
