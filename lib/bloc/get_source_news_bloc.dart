import 'package:flutter/cupertino.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceNewsBloc {
  final NewRepository _repository = NewRepository();
  final BehaviorSubject<ArticleRespone> _subject =
      BehaviorSubject<ArticleRespone>();
  getSourceNews(String sourceId) async {
    ArticleRespone respone = await _repository.getSourceNews(sourceId);
    _subject.sink.add(respone);
  }

  void drainstream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<ArticleRespone> get subject => _subject;
}

final GetSourceNewsBloc getSourceNewsBloc = GetSourceNewsBloc();
