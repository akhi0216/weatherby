import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/weather_controller.dart';
import '../model/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecast({required this.hourly, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white.withOpacity(0.85),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, index) {
              final h = hourly[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(h.iconUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.7),
                          BlendMode.lighten,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(h.hour, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text('${h.temp}°', style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TodayMetrics extends StatelessWidget {
  final WeatherModel weather;

  const TodayMetrics({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      {'icon': Icons.thermostat_outlined, 'label': 'Temperature', 'value': '${weather.tempMin}° / ${weather.tempMax}°'},
      {'icon': Icons.umbrella_outlined, 'label': 'Precipitation', 'value': '${weather.precipitation} %'},
      {'icon': Icons.air, 'label': 'Wind', 'value': '${weather.windSpeed} km/h'},
      {'icon': Icons.opacity, 'label': 'Humidity', 'value': '${weather.humidity} %'},
      {'icon': Icons.speed, 'label': 'Pressure', 'value': '${weather.pressure} hPa'},
      {'icon': Icons.visibility_outlined, 'label': 'Visibility', 'value': '${weather.visibility} km'},
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: metrics.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(m['icon'] as IconData, size: 26, color: Colors.blueAccent),
                  ),
                  const SizedBox(width: 18),
                  Text(m['label'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(m['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherCtrl = Get.find<WeatherController>();
    final cityCtrl = TextEditingController(text: 'Kochi');

    return DefaultTabController(
      length: 1,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB2EBF2),
              Color(0xFFE0F7FA),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Weather', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            actions: [
              Container(width: 48),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Enter City',
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    style: const TextStyle(fontSize: 16),
                    onSubmitted: (city) => weatherCtrl.fetchWeather(city),
                  ),
                ),
                const SizedBox(height: 18),
                Obx(() {
                  if (weatherCtrl.isLoading.value) {
                    return const Expanded(child: Center(child: CircularProgressIndicator()));
                  }

                  final weather = weatherCtrl.weather.value;
                  if (weather == null) {
                    return const Expanded(child: Center(child: Text('No weather data', style: TextStyle(fontSize: 18, color: Colors.grey))));
                  }

                  return Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 4),
                              child: Text(
                                cityCtrl.text,
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                              ),
                            ),
                            const SizedBox(height: 8),
                            HourlyForecast(hourly: weather.hourly),
                            const SizedBox(height: 24),
                            const Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 12),
                            TodayMetrics(weather: weather),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
