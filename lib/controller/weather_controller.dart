import 'package:get/get.dart';
import '../model/weather_model.dart';
import '../services/weather_services.dart';

class WeatherController extends GetxController {
  var weather = Rxn<WeatherModel>();
  var isLoading = false.obs;

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    final data = await WeatherService().getWeather(city);
    weather.value = data;
    isLoading.value = false;
  }
}
