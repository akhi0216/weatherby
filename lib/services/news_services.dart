
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class NewsService {
  final _apiKey = 'a21defb1070a4d7f87cf552f2ebc2069';

  Future<List<NewsArticle>> getNews() async {
    final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=in&category=weather&apiKey=$_apiKey',
    ));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return (jsonBody['articles'] as List)
          .map((e) => NewsArticle.fromJson(e))
          .toList();
    }
    return [];
  }
}