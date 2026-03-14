import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/news_model.dart';

class ApiService {

  final String apiKey = "2b55b36f0705418cb636e349c0f8dbcd";

  Future<List<NewsArticle>> fetchNews() async {

    final box = Hive.box('newsBox');

    try {

      final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey"
      );

      final response = await http.get(url);

      print("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {

        final data = json.decode(response.body);

        List articles = data['articles'];

        /// Convert JSON → NewsArticle objects
        List<NewsArticle> newsList =
            articles.map((e) => NewsArticle.fromJson(e)).toList();

        /// Save as JSON (not objects)
        await box.put(
          'news',
          newsList.map((e) => {
            "title": e.title,
            "description": e.description,
            "imageUrl": e.imageUrl,
            "source": e.source
          }).toList(),
        );

        return newsList;
      }

    } catch (e) {

      print("API FAILED → USING CACHE");
      print(e);

    }

    /// LOAD CACHE
    final cached = box.get('news');

    if (cached != null) {

      List<NewsArticle> cachedNews = (cached as List)
          .map((e) => NewsArticle(
                title: e["title"],
                description: e["description"],
                imageUrl: e["imageUrl"],
                source: e["source"],
              ))
          .toList();

      return cachedNews;
    }

    return [];
  }
}