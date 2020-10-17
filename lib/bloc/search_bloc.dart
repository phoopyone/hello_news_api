import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final NewRepository _repository = NewRepository();
  BehaviorSubject<ArticleRespone> _subject = BehaviorSubject<ArticleRespone>();
  search(String value) async {
    ArticleRespone respone = await _repository.search(value);
    _subject.sink.add(respone);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleRespone> get subject => _subject;
}

final SearchBloc searchBloc = SearchBloc();
