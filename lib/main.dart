import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:g_weather_forecast/core/providers/weather_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/api/mail_subscribe_api.dart';
import 'core/api/weather_api.dart';

void main() async {
  //debugPaintSizeEnabled = false;

  await dotenv.load(fileName: 'assets/.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              WeatherProvider(WeatherApi(Dio()), MailSubscribeApi(Dio())),
        ),
      ],
      child: App(),
    ),
  );
}
