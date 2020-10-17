import 'package:hello_news_api_tut/model/article.dart';
import 'package:hello_news_api_tut/model/source.dart';

class SourceRespone {
  final List<SourceModel> sources;
  final String error;
  SourceRespone(this.sources, this.error);

  SourceRespone.fromJson(Map<String, dynamic> json)
      : sources = (json["sources"] as List)
            .map((e) => new SourceModel.fromJson(e))
            .toList(),
        error = "";
  SourceRespone.withError(String errorValue)
      : sources = List(),
        error = errorValue;
}
