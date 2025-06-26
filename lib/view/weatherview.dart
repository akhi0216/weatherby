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
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final h = hourly[index];
          return Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(h.iconUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(h.hour, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('${h.temp}°', style: const TextStyle(color: Colors.grey)),
            ],
          );
        },
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

    return Column(
      children: metrics.map((m) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(m['icon'] as IconData, size: 24),
    ),
    const SizedBox(width: 16),
    Text(m['label'] as String, style: const TextStyle(fontSize: 16)),
    const Spacer(),
    Text(m['value'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
  ],
),

        );
      }).toList(),
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: const Icon(Icons.menu),
          actions: const [SizedBox(width: 48)],
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Hourly'),
              Tab(text: 'Daily'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'Enter City',
                  suffixIcon: Icon(Icons.search),
                ),
                onSubmitted: (city) => weatherCtrl.fetchWeather(city),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (weatherCtrl.isLoading.value) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }

                final weather = weatherCtrl.weather.value;
                if (weather == null) {
                  return const Expanded(child: Center(child: Text('No weather data')));
                }

                return Expanded(
                  child: TabBarView(
                    children: [
                      ListView(
                        children: [
                          Text(
                            cityCtrl.text,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          HourlyForecast(hourly: weather.hourly),
                          const SizedBox(height: 24),
                          const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          TodayMetrics(weather: weather),
                        ],
                      ),
                      ListView(
                        children: const [
                          Center(child: Text('Daily Forecast (to be implemented)')),
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
    );
  }
}
