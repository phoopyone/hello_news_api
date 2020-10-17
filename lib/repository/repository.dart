import 'package:dio/dio.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/model/source_response.dart';

class NewRepository {
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "fc5200ee644d4e36bb0e1a590ba42264";
  final Dio _dio = Dio();
  var getSourceUrl = "$mainUrl/sources";

  var getTopHeadlineUrl = "$mainUrl/top-headlines";
  var everythingUrl = "$mainUrl/everything";

  Future<SourceRespone> getSources() async {
    var params = {"apiKey": apiKey, "language": "en", "country": "us"};
    try {
      Response response = await _dio.get(getSourceUrl, queryParameters: params);
      return SourceRespone.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception Occured:$error ");
      return SourceRespone.withError(error);
    }
  }

  Future<ArticleRespone> getTopHeadLines() async {
    var params = {"country": "us", "apiKey": apiKey};
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleRespone.fromJson(response.data);
    } catch (error) {
      print("Exception Occured: $error ");
      //   return ArticleRespone.withError(error);
    }
  }

  Future<ArticleRespone> getHotNews() async {
    var params = {
      "apiKey": apiKey,
      "q": "apple",
      "sortBy": "popularity",
    };
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleRespone.fromJson(response.data);
    } catch (error) {
      print("Exception Occured:$error ");
      // return ArticleRespone.withError(error);
    }
  }

  Future<ArticleRespone> getSourceNews(String sourceId) async {
    var params = {
      "apiKey": apiKey,
      "sources": sourceId,
    };
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleRespone.fromJson(response.data);
    } catch (error) {
      print("Exception Occured:$error ");
      return ArticleRespone.withError(error);
    }
  }

  Future<ArticleRespone> search(String searchValue) async {
    var params = {
      "apiKey": apiKey,
      "q": searchValue,
    };
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleRespone.fromJson(response.data);
    } catch (error) {
      print("Exception Occured:$error ");
      return ArticleRespone.withError(error);
    }
  }
}
