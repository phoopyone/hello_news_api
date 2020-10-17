import 'package:hello_news_api_tut/model/source_response.dart';
import 'package:hello_news_api_tut/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceBloc {
  final NewRepository _repository = NewRepository();
  final BehaviorSubject<SourceRespone> _subject = BehaviorSubject();

  getSources() async {
    SourceRespone respone = await _repository.getSources();
    _subject.sink.add(respone);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SourceRespone> get subject => _subject;
}

final GetSourceBloc getSourceBloc = GetSourceBloc();
