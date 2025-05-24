import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/mydata.dart';
import '../model/newsinfo_model.dart';


class NewsService {
  final String baseUrl = MyData.baseUrl;

  Future<List<Article>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/everything?q=$query&apiKey=${MyData.apiKey}'),
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
