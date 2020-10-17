import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hello_news_api_tut/bloc/get_top_headlines_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/article.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadLineSliderWidget extends StatefulWidget {
  @override
  _HeadLineSliderWidgetState createState() => _HeadLineSliderWidgetState();
}

class _HeadLineSliderWidgetState extends State<HeadLineSliderWidget> {
  @override
  void initState() {
    getTopHeadlineBloc.getHeadlines();
    print(getTopHeadlineBloc.subject);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleRespone>(
      stream: getTopHeadlineBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<ArticleRespone> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildHeadLineSlider(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
          // return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadLineSlider(ArticleRespone data) {
    List<ArticleModel> articles = data.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            height: 200,
            viewportFraction: 0.9),
        items: getExpenseSlider(articles),
      ),
    );
  }

  getExpenseSlider(List<ArticleModel> articles) {
    return articles
        .map((article) => GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(
                    left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: article.img == null
                                ? NetworkImage(
                                    "https://1.bp.blogspot.com/-YBo2TSXxvvo/XdAmLi0noKI/AAAAAAAABGE/_pDiY6XEMIUwGqYU5RLWBwoU5FXLcBgbQCNcBGAsYHQ/s1600/shraddha-kapoor-hd-wallpaper.jpg")
                                : NetworkImage(article.img)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                                0.1,
                                0.9,
                              ],
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.white.withOpacity(0.0)
                              ])),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0),
                        width: 250.0,
                        child: Column(
                          children: [
                            Text(
                              article.title,
                              style: TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: article.source.name == null
                          ? Center(
                              child: Text("Error"),
                            )
                          : Text(
                              article.source.name,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9.0,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Text(
                        timeAgo(DateTime.parse(article.date)),
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
