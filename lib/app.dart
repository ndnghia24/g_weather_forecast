import 'package:flutter/material.dart';
import 'package:g_weather_forecast/ui/layouts/mobile_layout/mobile_weather_dashboard.dart';
import 'package:g_weather_forecast/ui/layouts/web_layout/web_weather_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q - Weather Forecast',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      home: ResponsiveLayout(),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return MobileWeatherDashboard();
    } else {
      return WebWeatherDashboard();
    }
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
