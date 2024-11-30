import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_weather_forecast/core/models/location_model.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';
import 'package:g_weather_forecast/ui/widgets/current_weather_widget.dart';
import 'package:g_weather_forecast/ui/widgets/forecast_widget.dart';
import 'package:g_weather_forecast/ui/widgets/weather_appbar.dart';
import 'package:g_weather_forecast/ui/widgets/weather_search_widget.dart';
import 'package:provider/provider.dart';

class WebWeatherDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F0FF),
      appBar: WeatherAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Section
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Search for a City",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          WeatherSearchWidget(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                  // Weather Display Section
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Consumer<WeatherProvider>(
                        builder: (context, provider, _) {
                          final currentWeather = provider.currentWeather;
                          final forecast = provider.forecast;

                          if (currentWeather == null) {
                            return Center(
                              child: Text(
                                "No weather data available. Please search for a city.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Weather
                              CurrentWeatherWidget(),
                              const SizedBox(height: 16),
                              // 4-Day Forecast
                              ForecastWidget(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
