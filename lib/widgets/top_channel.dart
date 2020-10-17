import 'package:flutter/material.dart';
import 'package:hello_news_api_tut/bloc/get_source_bloc.dart';
import 'package:hello_news_api_tut/elements/error_element.dart';
import 'package:hello_news_api_tut/elements/loading_element.dart';
import 'package:hello_news_api_tut/model/source.dart';
import 'package:hello_news_api_tut/model/source_response.dart';
import 'package:hello_news_api_tut/screens/source_detail.dart';

class TopChannels extends StatefulWidget {
  @override
  _TopChannelsState createState() => _TopChannelsState();
}

class _TopChannelsState extends State<TopChannels> {
  @override
  void initState() {
    getSourceBloc..getSources();

    super.initState();
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
          return _buildTopChannels(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
          // return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannels(SourceRespone data) {
    List<SourceModel> sources = data.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text("No Resources")],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              width: 80.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SourceDetail(source: sources[index]);
                  }));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        width: 50.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.0, 1.0))
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://1.bp.blogspot.com/-YBo2TSXxvvo/XdAmLi0noKI/AAAAAAAABGE/_pDiY6XEMIUwGqYU5RLWBwoU5FXLcBgbQCNcBGAsYHQ/s1600/shraddha-kapoor-hd-wallpaper.jpg"),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      sources[index].name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      sources[index].name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 9.0),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
