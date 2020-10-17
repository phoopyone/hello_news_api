import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetHotNewsBloc {
  final NewRepository _repository = NewRepository();
  final BehaviorSubject<ArticleRespone> _subject =
      BehaviorSubject<ArticleRespone>();
  getHotNews() async {
    ArticleRespone respone = await _repository.getHotNews();
    _subject.sink.add(respone);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleRespone> get subject => _subject;
}

final GetHotNewsBloc getHotNewsBloc = GetHotNewsBloc();
