// lib/widgets/current_weather_widget.dart
import 'package:flutter/material.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class CurrentWeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final currentWeather = provider.currentWeather;

        if (currentWeather == null) {
          return Center(
            child: Text(
              "No weather data available. Please search for a city.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Card(
          color: const Color(0xFF6B8BF5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${provider.city.name} (${currentWeather.date.toIso8601String().substring(0, 10)})",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Temperature: ${currentWeather.tempC}°C",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Wind: ${currentWeather.windSpeed} M/S",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Humidity: ${currentWeather.humidity}%",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Image.network(
                          currentWeather.conditionIcon,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 4),
                        Text(currentWeather.conditionText),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
