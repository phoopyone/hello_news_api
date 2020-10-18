import 'package:flutter/material.dart';
import 'package:hello_news_api_tut/bloc/get_source_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/source.dart';
import 'package:hello_news_api_tut/model/source_response.dart';

import '../source_detail.dart';

class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getSourceBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceRespone>(
      stream: getSourceBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<SourceRespone> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildSources(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
          // return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildSources(SourceRespone data) {
    List<SourceModel> sources = data.sources;
    return GridView.builder(
      itemCount: sources.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.86),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SourceDetail(source: sources[index]);
                }));
              },
              child: Container(
                width: 100.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(1.0, 1.0))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(""), fit: BoxFit.cover)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Text(
                        sources[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
