import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/newsinfo_model.dart';

class NewsService {
  final String apiKey =
      'fe1e385dd8584b14ba46088b2115af61'; // Replace with your NewsAPI.org API key
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      List<Article> articlesWithModelClass =
          articles.map((json) => Article.fromJson(json)).toList();
      return sortByDate(articlesWithModelClass);
    } else {
      throw Exception('Failed to load search results');
    }
  }

  List<Article> sortByDate(List<Article> articles) {
    articles.sort((a, b) {
      DateTime dateA = DateTime.parse(a.publishedAt);
      DateTime dateB = DateTime.parse(b.publishedAt);
      return dateB.compareTo(dateA); // Sort in descending order (newest first)
    });
    return articles;
  }
}
