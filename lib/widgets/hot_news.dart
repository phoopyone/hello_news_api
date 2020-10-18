import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:hello_news_api_tut/bloc/get_hotnews_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/article.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/screens/news_details.dart';
import 'package:hello_news_api_tut/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

class HotNews extends StatefulWidget {
  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  @override
  void initState() {
    getHotNewsBloc..getHotNews();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleRespone>(
      stream: getHotNewsBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<ArticleRespone> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildHotNews(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
          // return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHotNews(ArticleRespone data) {
    List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text("No Resources")],
        ),
      );
    } else {
      return Container(
        height: 500.0,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          scrollDirection: Axis.vertical,
          itemCount: articles.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
                  EdgeInsets.only(right: 15, top: 10.0, left: 15, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsDetail(
                      article: articles[index],
                    );
                  }));
                },
                child: Container(
                  width: 220.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(1.0, 1.0))
                      ]),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            image: DecorationImage(
                              image: articles[index].img == null
                                  ? NetworkImage("")
                                  : NetworkImage(articles[index].img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                        child: Text(
                          articles[index].title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(height: 1.3, fontSize: 15.0),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            width: 180.0,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 30.0,
                            height: 3.0,
                            color: Style.Colors.mainColor,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              articles[index].source.name,
                              style: TextStyle(
                                  color: Style.Colors.mainColor, fontSize: 9.0),
                            ),
                            Text(
                              timeAgo(DateTime.parse(articles[index].date)),
                              style: TextStyle(
                                  color: Style.Colors.mainColor, fontSize: 9.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: "en");
  }
}
