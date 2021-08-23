import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/alumniviewpost_chapter.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/strings.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class SchoolListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchoolListingState();
  }
}

_changeText() {}

class _SchoolListingState extends State<SchoolListing> {
  TextEditingController chapterSearchController = TextEditingController();

  bool isSearching = false;
  bool showSearchCard = false;

  bool showMainCard = true;

  Color changeStatusColor(status) {
    if (status == "pending") {
      return Colors.grey;
    } else if (status == "Accepted") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  bool isPending = false;
  List<String> uche = [
    KAppBarMembers,
    KAppBarMySet,
    KAppBarChapter,
    KAppBarAdmin
  ];
  void checkRequestStatus(status, schoolAccountId) {
    FirebaseFirestore.instance
        .collection('sentChapterRequest')
        .where('status', isEqualTo: status)
        .where('schAccId', isEqualTo: schoolAccountId)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
    });
  }

  int _value = 0;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 100.0,
            ),
            child: TextField(
              controller: chapterSearchController,
              onChanged: (value) {
                value = value.toLowerCase();
                if (chapterSearchController.text.length != 0) {
                  setState(() {
                    showSearchCard = true;
                    showMainCard = false;
                  });
                } else {
                  setState(() {
                    showMainCard = true;
                    showSearchCard = false;
                  });
                }
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_sharp),
                hintText: "search chapter",
                hintStyle: TextStyle(
                  color: kAGrey,
                  fontFamily: "Rajdhani",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: isSearching
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: kAGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                      });
                    },
                  )
                : IconButton(
                    icon: SvgPicture.asset(
                      "images/alumni/searchbutton.svg",
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
          ),
          Container(
            child: Container(
              child: Visibility(
                visible: showMainCard,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('createSchoolChapter')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // final chapters = snapshot.data.docs;

                      List<Map<String, dynamic>?> chapters =
                          snapshot.data!.docs.map((DocumentSnapshot doc) {
                        return doc.data as Map<String, dynamic>?;
                      }).toList();
                      print(chapters);
                      if (chapters.isEmpty) {
                        return Text(
                          "No Chapters Available",
                          style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kAWhite,
                          ),
                        );
                      } else {
                        List<Widget> cardWidgets = [];
                        for (var chapter in chapters) {
                          checkRequestStatus(
                              chapter!['status'], chapter['schAccId']);
                          print(chapter['logo']);
                          final cardWidget = Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ChapterCards(createChapter: chapter),
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
            ),
          ),
          Container(
            child: Visibility(
              visible: showSearchCard,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('createSchoolChapter')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final chapters = snapshot.data!.docs.where((a) => a['name']
                        .contains(chapterSearchController.text.toLowerCase()));
                    if (chapters.isEmpty) {
                      return Center(child: Text("No Search Result Found"));
                    } else {
                      List<Widget> cardWidgets = [];
                      for (var chapter in chapters) {
                        Map<String, dynamic> data =
                            chapter as Map<String, dynamic>;
                        checkRequestStatus(data['status'], data['schAccId']);
                        print(data['logo']);
                        final cardWidget = Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ChapterCards(createChapter: data),
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
          ),
        ],
      ),
    ));
  }
}

class ChapterCards extends StatelessWidget {
  const ChapterCards({
    Key? key,
    required this.createChapter,
  }) : super(key: key);

  // final DocumentSnapshot createChapter;
  final Map<String, dynamic>? createChapter;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child: Row(children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: createChapter!['sl'] ??
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
                              Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          createChapter!['schNam'] ?? "school",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                        Text(
                                          createChapter!["chapName"] ?? "school",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          createChapter!["chapLcn"] ?? "school",
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
                                              ]),
                                        )
                                      ],
                                    ),
                                  )
                                ])
                              ])
                            ]))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.fromLTRB(1, 60, 0, 0),
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    )),
                    onPressed: () async {
                      final QuerySnapshot result = await FirebaseFirestore
                          .instance
                          .collection('chapterRequest')
                          .where('schUid', isEqualTo: createChapter!["uid"])
                          .where('uid', isEqualTo: UserStorage.loggedInUser.uid)
                          .get();
                      final List<DocumentSnapshot> documents = result.docs;

                      if (documents.length >= 1) {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AlumniViewPost()));
                      } else {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('chapterRequest')
                            .doc();
                        documentReference.set({
                          'schUid': createChapter!["uid"],
                          'chtNm': createChapter!["chapName"],
                          'uid': UserStorage.loggedInUser.uid,
                          'status': "pending",
                          'id': documentReference.id,
                          'time': DateTime.now()
                        });
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AlumniViewPost()));

                        Fluttertoast.showToast(
                            msg: "CHAPTER JOINED",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.green,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            textColor: Colors.white);
                      }
                    },
                    splashColor: kAWhite,
                    child: Text(
                      kAppBarJoin,
                      style: TextStyle(
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kAWhite,
                      ),
                    ),
                    color: kADeepOrange,
                  ),
                ),
              ),
            ])));
  }
}

// read data and pass to screen
// DocumentReference documentReference = FirebaseFirestore.instance.collection('chapterRequest').doc();
// documentReference.set({
//   'schUid':createChapter.data()["chapLcn"],
//   'chtNm': createChapter.data()["chapName"],
//   'status': "pending",
//   'id': documentReference.id,
//   'time':DateTime.now()
// });
