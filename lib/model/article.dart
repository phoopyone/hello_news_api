import 'package:hello_news_api_tut/model/source.dart';

class ArticleModel {
  final SourceModel source;
  String aurhor;
  String title;
  String description;
  String url;
  String img;
  String date;
  var content;
  ArticleModel(this.source, this.aurhor, this.title, this.description, this.url,
      this.img, this.date, this.content);
  ArticleModel.fromJson(Map<String, dynamic> json)
      : source = SourceModel.fromJson(json["source"]),
        aurhor = json["author"],
        title = json["title"],
        description = json['description'],
        url = json['url'],
        img = json['urlToImage'],
        date = json['publishedAt'],
        content = json['content'];
}
