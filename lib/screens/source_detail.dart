import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:hello_news_api_tut/bloc/get_source_bloc.dart';
import 'package:hello_news_api_tut/bloc/get_source_news_bloc.dart';
import 'package:hello_news_api_tut/bloc/get_top_headlines_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/article.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/model/source.dart';
import 'package:hello_news_api_tut/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

class SourceDetail extends StatefulWidget {
  final SourceModel source;
  SourceDetail({Key key, @required this.source}) : super(key: key);
  @override
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;
  _SourceDetailState(this.source);

  @override
  void initState() {
    getSourceNewsBloc.getSourceNews(source.id);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getSourceNewsBloc..drainstream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(""),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
            color: Style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id,
                  child: SizedBox(
                    child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://1.bp.blogspot.com/-YBo2TSXxvvo/XdAmLi0noKI/AAAAAAAABGE/_pDiY6XEMIUwGqYU5RLWBwoU5FXLcBgbQCNcBGAsYHQ/s1600/shraddha-kapoor-hd-wallpaper.jpg"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<ArticleRespone>(
              stream: getTopHeadlineBloc.subject.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<ArticleRespone> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return buildErrorWidget(snapshot.data.error);
                  }
                  return _buildSourceNews(snapshot.data);
                } else if (snapshot.hasError) {
                  return buildErrorWidget(snapshot.data.error);
                } else {
                  return buildLoadingWidget();
                  // return buildLoadingWidget();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSourceNews(ArticleRespone data) {
    List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        child: Text("No Articles"),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 1.0)),
                  color: Colors.grey),
              height: 150.0,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      children: [
                        Text(
                          articles[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14.0),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text(
                                  timeAgo(
                                    DateTime.parse(
                                      articles[index].date,
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130.0,
                    child: Image(
                      image: articles[index].img == null
                          ? AssetImage("assets/hoto.png")
                          : NetworkImage(articles[index].img),
                    ),
                    // child: FadeInImage.assetNetwork(
                    //   placeholder: "assets/hoto.png",
                    //   image: articles[index].img,
                    //   fit: BoxFit.fitHeight,
                    //   width: double.maxFinite,
                    //   height: MediaQuery.of(context).size.height * 1 / 3,
                    // )
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
