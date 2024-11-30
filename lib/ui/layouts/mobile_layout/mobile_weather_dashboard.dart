import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_weather_forecast/ui/widgets/current_weather_widget.dart';
import 'package:g_weather_forecast/ui/widgets/forecast_widget.dart';
import 'package:g_weather_forecast/ui/widgets/weather_appbar.dart';
import 'package:g_weather_forecast/ui/widgets/weather_search_widget.dart';

class MobileWeatherDashboard extends StatelessWidget {
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
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Search for a City",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          WeatherSearchWidget(),
                          const SizedBox(height: 16),
                          CurrentWeatherWidget(),
                          const SizedBox(height: 16),
                          ForecastWidget(),
                        ],
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
