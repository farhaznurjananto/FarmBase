import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:farmbase/model/weather_model.dart';

class WeatherController {
  Future<Weather> getWeather(Position position) async {
    const apiKey = 'b82e21a076c1cf058ecf95f20280a5b1';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);
    final location = data['name'];
    final description = data['weather'][0]['description'];
    final temperature = data['main']['temp'];
    final iconCode = data['weather'][0]['icon'];
    return Weather(
        location: location,
        description: description,
        temperature: double.parse('$temperature'),
        iconCode: iconCode);
  }
}
