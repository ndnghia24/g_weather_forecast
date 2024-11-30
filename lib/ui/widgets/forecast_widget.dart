// lib/widgets/forecast_widget.dart
import 'package:flutter/material.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class ForecastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final forecast = provider.forecast;

        if (forecast.isEmpty) {
          return Container(); // No forecast data
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "4-Day Forecast",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                double itemWidth = constraints.maxWidth / 4;

                if (constraints.maxWidth < 600) {
                  itemWidth = constraints.maxWidth / 2;
                }

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      var forecastData = forecast[index];
                      return SizedBox(
                        width: itemWidth,
                        child: Card(
                          color: Colors.grey.shade500,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "(${forecastData.date.toIso8601String().substring(0, 10)})",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Image.network(
                                    forecastData.conditionIcon,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Temp: ${forecastData.tempC}°C"),
                                  Text("Wind: ${forecastData.windSpeed} M/S"),
                                  Text("Humidity: ${forecastData.humidity}%"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
