import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:hello_news_api_tut/screens/news_details.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hello_news_api_tut/bloc/search_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/article.dart';
import 'package:hello_news_api_tut/model/article_response.dart';
import 'package:hello_news_api_tut/style/theme.dart' as Style;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    searchBloc..search("value");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            controller: _searchController,
            onChanged: (value) {
              searchBloc.search(_searchController.text);
            },
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                suffix: _searchController.text.length > 0
                    ? IconButton(
                        icon: Icon(EvaIcons.backspaceOutline),
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _searchController.clear();
                            searchBloc..search(_searchController.text);
                          });
                        })
                    : Icon(
                        EvaIcons.searchOutline,
                        color: Colors.grey[500],
                        size: 16.0,
                      ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[100].withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.only(
                  left: 15.0,
                  right: 10.0,
                ),
                labelText: "Search...",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Style.Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                labelStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            autocorrect: false,
            autovalidate: true,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleRespone>(
            stream: searchBloc.subject.stream,
            builder:
                (BuildContext context, AsyncSnapshot<ArticleRespone> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return buildErrorWidget(snapshot.data.error);
                }
                return _buildSearchNews(snapshot.data);
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
    );
  }

  Widget _buildSearchNews(ArticleRespone data) {
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
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewsDetail(
                  article: articles[index],
                );
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 1.0)),
                  color: Colors.white),
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
