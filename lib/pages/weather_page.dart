import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Assuming you use Lottie for animations
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('f3dde99b1f4c631e8de95ab23823c2a4');
  Weather? _weather;

  // Fetch weather
  Future<void> _fetchWeather() async {
    // Get city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
    }
  }

  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the weather
    _fetchWeather();
  }

  // Check pubspec.yaml if it didn't work
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading city..."),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text('${_weather?.temperature.round()} °C'),
          ],
        ),
      ),
    );
  }
}
