import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/alumni/alumniviewpost_chapter.dart';

class ChapterViewAll extends StatefulWidget {
  @override
  ChapterViewAllState createState() => ChapterViewAllState();
}

class ChapterViewAllState extends State<ChapterViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onLongPress: () {},
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        title: Center(child: Text('Created chapter')),
        backgroundColor: kADarkRed,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('createSchoolChapter')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // final createChapters = snapshot.data.docs;

                    List<Map<String, dynamic>> createChapters =
                        snapshot.data!.docs.map((doc) {
                      return doc.data as Map<String, dynamic>;
                    }).toList();
                    if (createChapters.isEmpty) {
                      return Center(
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Text(
                              "No Chapter Available",
                              style: TextStyle(
                                fontFamily: "Rajdhani",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kAWhite,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      List<Widget> cardWidgets = [];
                      for (var createChapter in createChapters) {
                        final cardWidget =
                            ChapterCards(createChapter: createChapter);
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
                            backgroundColor: Colors.green,
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
                            backgroundColor: Colors.red,
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
            ],
          ),
        ),
      ),
    );
  }
}

class ChapterCards extends StatelessWidget {
  const ChapterCards({
    Key? key,
    required this.createChapter,
  }) : super(key: key);

  // final DocumentSnapshot createChapter;
  final Map<String, dynamic> createChapter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: AlumniViewPost()));
      },
      child: Card(
        elevation: 10.0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: createChapter['sl'] ??
                            "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          createChapter['schNam'] ?? "school",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                        Text(
                                          createChapter["chapName"] ?? "school",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          createChapter["chapLcn"] ?? "school",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 28, 0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${MarketBrain.numberFormatter(398888)}",
                                                      style: new TextStyle(
                                                          color: kABlack,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.0),
                                                    ),
                                                    Text(
                                                      "members.",
                                                      style: new TextStyle(
                                                          color: kABlack,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${MarketBrain.numberFormatter(300)}",
                                                      style: new TextStyle(
                                                          color: kABlack,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.0),
                                                    ),
                                                    Text(
                                                      "post.",
                                                      style: new TextStyle(
                                                          color: kABlack,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
