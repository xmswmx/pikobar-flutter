import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class NewsScreen extends StatefulWidget {
  final bool isLiveUpdate;
  final int maxLength;

  NewsScreen({@required this.isLiveUpdate, this.maxLength});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.isLiveUpdate? Firestore.instance.collection('articles').snapshots():Firestore.instance.collection('articles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoading();
          default:
            return _buildContent(snapshot);
        }
      },
    );
  }

  _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.only(bottom: 10.0),
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.maxLength!= null ? snapshot.data.documents.length > 3
                    ? 3
                    : snapshot.data.documents.length:snapshot.data.documents.length,
                padding: const EdgeInsets.only(bottom: 10.0),
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data.documents[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      onPressed: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => NewsDetailScreen(
//                                      newsId: state.listtNews[index].id,
//                                      isIdKota: _isIdKota))
//                          );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: document['image'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      heightFactor: 4.2,
                                      child: CupertinoActivityIndicator()),
                                  errorWidget: (context, url, error) => Container(
                                      height: MediaQuery.of(context).size.height /
                                          3.3,
                                      color: Colors.grey[200],
                                      child: Image.asset(
                                          '${Environment.imageAssets}placeholder_square.png',
                                          fit: BoxFit.fitWidth)),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              width: MediaQuery.of(context).size.width - 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document['title'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                        Image.network(
                                          document['news_channel_icon'],
                                          width: 25.0,
                                          height: 25.0,
                                        ),
                                              SizedBox(width: 3.0),
                                              Text(
                                                document['news_channel'],
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            unixTimeStampToDateTime(
                                                document['published_at'].seconds),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int dex) => Divider()),
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RoundedButton(
                height: 52,
                  minWidth: MediaQuery.of(context).size.width,
                  title: Dictionary.more,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue,
                  textStyle: Theme.of(context).textTheme.subhead.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onPressed: (){
                    print('cekkk');
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoading() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 5.0, bottom: 10.0),
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Skeleton(
                    height: 20.0,
                    width: MediaQuery.of(context).size.width / 4,
                    padding: 10.0,
                  ),
                  Skeleton(
                    height: 20.0,
                    width: MediaQuery.of(context).size.width / 4,
                    padding: 10.0,
                  ),
                ],
              ),
            ), //
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 90.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Skeleton(
                                height: 20.0,
                                width: MediaQuery.of(context).size.width,
                              )),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Skeleton(
                                      height: 35.0,
                                      width: 35.0,
                                    ),
                                    Skeleton(
                                      height: 25.0,
                                      width: 100.0,
                                      margin: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Skeleton(
                              height: 300.0,
                              width: MediaQuery.of(context).size.width / 3),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int dex) => Divider()),
          ],
        ),
      ),
    );
  }
}
