import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/alumni/color/colors.dart';

enum AcceptButton {
  delete,
  acceptUser,
  viewProfile,
}

class ChapterDeclinedRequest extends StatefulWidget {
  @override
  _ChapterDeclinedRequestState createState() => _ChapterDeclinedRequestState();
}

class _ChapterDeclinedRequestState extends State<ChapterDeclinedRequest> {
  Widget _selectPopup() => PopupMenuButton<AcceptButton>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: AcceptButton.acceptUser,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "ReAccept User",
                style: TextStyle(
                    fontFamily: "Rajdhani",
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          PopupMenuItem(
            value: AcceptButton.viewProfile,
            child: Text(
              "View Profile",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        offset: Offset(0, 100),
        icon: Icon(Icons.more_vert),
      );
  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sentChapterRequest')
                  //.where('schUid', isEqualTo: sparksUser.uid)
                  .where('status', isEqualTo: "Declined")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final chapterRequests = snapshot.data.docs;

                  List<Map<String, dynamic>> chapterRequests =
                      snapshot.data!.docs.map((doc) {
                    return doc.data as Map<String, dynamic>;
                  }).toList();
                  if (chapterRequests.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              "No Request Available",
                              style: TextStyle(
                                fontFamily: "Rajdhani",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kAWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<Widget> cardWidgets = [];
                    for (var chapterRequest in chapterRequests) {
                      final cardWidget = Card(
                        elevation: 10.0,
                        color: kAWhite,
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    color: kAWhite,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.97,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 9,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 22.0, bottom: 0.0),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 32,
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl: chapterRequest[
                                                              'logo'] ??
                                                          "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                      width: 40.0,
                                                      height: 40.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 40,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0, left: 5.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          chapterRequest[
                                                                  'name'] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 21.0),
                                                        ),
                                                        Text(
                                                          chapterRequest[
                                                                  'grade'] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          chapterRequest[
                                                                  'schName'] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0),
                                                        ),
                                                        Text(
                                                          chapterRequest[
                                                                  'year'] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              child: _selectPopup(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ],
                        ),
                      );
                      cardWidgets.add(cardWidget);
                    }
                    return Column(
                      children: cardWidgets,
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  print('waiting');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print('has error');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  );
                } else {
                  print('nothing');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
