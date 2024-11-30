import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:g_weather_forecast/core/models/location_model.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class WeatherSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            TypeAheadField<LocationModel>(
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "E.g., New York, London, Tokyo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              emptyBuilder: (context) {
                return const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      "Start typing a city name...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
              loadingBuilder: (context) {
                return const SizedBox(
                  height: 50,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                if (pattern.length < 1) {
                  return [];
                }
                return await provider.searchCities(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.country),
                );
              },
              onSelected: (LocationModel value) {
                provider.setCity(value);
                provider.fetchWeather();

                // Clear the text field
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider()),
                const SizedBox(width: 8),
                const Text("or"),
                const SizedBox(width: 8),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                LocationModel location = await provider.getCurrentLocation();
                provider.setCity(location);
                provider.fetchWeather();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B8BF5),
                foregroundColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                minimumSize: Size(200, 60),
              ),
              child: const Center(
                child: Text(
                  "Use Current Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
