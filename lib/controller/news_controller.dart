import 'package:get/get.dart';
import '../model/news_model.dart';
import '../services/news_services.dart';
import 'weather_controller.dart';

enum NewsCategory { local, international, sports, technology }

final Map<String, List<String>> weatherTopicMap = {
  'clear': ['travel', 'outdoor', 'sunshine', 'picnic'],
  'clouds': ['climate', 'forecast', 'overcast'],
  'rain': ['flood', 'storm', 'rain', 'accident', 'disaster'],
  'drizzle': ['light rain', 'forecast', 'climate'],
  'thunderstorm': ['storm', 'emergency', 'alert', 'lightning'],
  'snow': ['snow', 'cold', 'blizzard', 'winter'],
  'mist': ['fog', 'air quality', 'visibility'],
  'haze': ['pollution', 'air quality', 'smog'],
  'smoke': ['fire', 'smoke', 'hazard'],
  'dust': ['sandstorm', 'visibility', 'dry weather'],
  'fog': ['low visibility', 'road', 'air travel'],
  'sand': ['desert', 'heatwave'],
  'ash': ['volcano', 'eruption'],
  'squall': ['wind', 'storm'],
  'tornado': ['disaster', 'tornado', 'emergency'],
};

class NewsController extends GetxController {
  var selectedCategory = NewsCategory.local.obs;
  var isLoading = false.obs;
  var articles = <NewsArticle>[].obs;

  final service = NewsService();
  final weatherCtrl = Get.find<WeatherController>();

  @override
  void onInit() {
    super.onInit();
    ever(weatherCtrl.weather, (_) => fetchNews());
    fetchNews();
  }

  void updateCategory(NewsCategory cat) {
    selectedCategory.value = cat;
    fetchNews();
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    final cat = _categoryToString(selectedCategory.value);
    String categoryToFetch = cat;
    if (selectedCategory.value == NewsCategory.local) {
      final weatherMain = weatherCtrl.weather.value?.main.toLowerCase() ?? '';
      if (weatherMain.isNotEmpty) {
        categoryToFetch = 'weather';
      }
    }
    final country = weatherCtrl.weather.value?.country?.toLowerCase() ?? 'us';
    final fetched = await service.getNews(category: categoryToFetch, country: country);

    final weatherMain = weatherCtrl.weather.value?.main.toLowerCase() ?? '';
    final relatedTopics = weatherTopicMap[weatherMain] ?? [];

    final filtered = relatedTopics.isEmpty
        ? fetched
        : fetched.where((article) {
            final text = '${article.title} ${article.description}'.toLowerCase();
            return relatedTopics.any((t) => text.contains(t));
          }).toList();

    articles.assignAll(filtered);
    isLoading.value = false;
  }

  String _categoryToString(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.international:
        return 'general';
      case NewsCategory.sports:
        return 'sports';
      case NewsCategory.technology:
        return 'technology';
      case NewsCategory.local:
        return 'weather';
    }
  }
}
