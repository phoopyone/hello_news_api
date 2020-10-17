import 'package:hello_news_api_tut/model/article.dart';

class ArticleRespone {
  final List<ArticleModel> articles;

  final String error;
  ArticleRespone(this.articles, this.error);

  ArticleRespone.fromJson(Map<String, dynamic> json)
      : articles = (json["articles"] as List)
            .map((e) => new ArticleModel.fromJson(e))
            .toList(),
        error = "";
  ArticleRespone.withError(String errorValue)
      : articles = List(),
        error = errorValue;
}
