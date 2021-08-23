import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/Alumni/schoolAdminEntry/Create_jobs.dart';
import 'package:sparks/Alumni/schoolAdminEntry/chapter_createnew.dart';
import 'package:sparks/Alumni/schoolAdminEntry/chapterrequest_tabs.dart';
import 'package:sparks/Alumni/schoolAdminEntry/jobs_tabs.dart';
import 'schoolrequest_tab.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class SchoolAdmin extends StatefulWidget {
  @override
  _SchoolAdminState createState() => _SchoolAdminState();
}

class _SchoolAdminState extends State<SchoolAdmin> {
  // User loggedInUser;
  @override
  Color _iconColor = kAGrey;

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: kAOffWhite,
                  height: 7.0,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: []),
                    ),
                  ],
                ),
              ],
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.003,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: RaisedButton(
                          elevation: 5,
                          onPressed: () {},
                          color: kAWhite,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Sell Products & Services",
                                style: TextStyle(
                                    color: kADeepOrange,
                                    fontFamily: "Rajdhani",
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.003,
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "images/alumni/school_icon.svg",
                            height: 20.0,
                            width: 20.0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Container(
                          child: Text(
                            "SCHOOL-NOTIFICATION",
                            style: TextStyle(
                                fontFamily: "Rajdhani",
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: kAOrangeRed),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('sentSchoolRequest')
                                    //.where('schUid', isEqualTo: loggedInUser.uid)
                                    .where('status', isEqualTo: "pending")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final numberOfSchoolRequest =
                                        snapshot.data!.docs;
                                    if (numberOfSchoolRequest.isEmpty) {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kADeepOrange,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kADeepOrange,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print('waiting');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    print('has error');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    print('nothing');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
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
                        Row(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('sentSchoolRequest')
                                    //.where('schUid', isEqualTo: loggedInUser.uid)
                                    .where('status', isEqualTo: "Accepted")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final numberOfSchoolRequest =
                                        snapshot.data!.docs;
                                    if (numberOfSchoolRequest.isEmpty) {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kAGreen,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'Accepted',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kAGreen,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'Accepted',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print('waiting');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    print('has error');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    print('nothing');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
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
                        Row(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('sentSchoolRequest')
                                    //.where('schUid', isEqualTo: loggedInUser.uid)
                                    .where('status', isEqualTo: "Declined")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final numberOfSchoolRequest =
                                        snapshot.data!.docs;
                                    if (numberOfSchoolRequest.isEmpty) {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kARed,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'Declined',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Badge(
                                          toAnimate: false,
                                          padding: EdgeInsets.all(4.0),
                                          badgeContent: Text(
                                            '${numberOfSchoolRequest.length}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: kARed,
                                          position: BadgePosition.topStart(
                                              top: -12, start: -14),
                                          child: Text(
                                            'Declined',
                                            style: TextStyle(
                                                fontFamily: "Rajdhani",
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kABlack),
                                          ),
                                        ),
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print('waiting');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    print('has error');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    print('nothing');
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
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
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SchoolRequestTab()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kADarkBlue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            height: 32.0,
                            child: Text(
                              "Review",
                              style: TextStyle(
                                  color: kAWhite,
                                  fontFamily: "Rajdhani",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              child: Container(
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          "images/alumni/write-letter.svg",
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        child: Text(
                          "CHAPTER REQUEST",
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: kAOrangeRed),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chapterRequest')
                                  .where('schUid',
                                      isEqualTo: UserStorage.loggedInUser.uid)
                                  .where('status', isEqualTo: "pending")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final numberOfSchoolRequest =
                                      snapshot.data!.docs;
                                  if (numberOfSchoolRequest.isEmpty) {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kADeepOrange,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'New',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kADeepOrange,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'New',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                      Row(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chapterRequest')
                                  //.where('schUid', isEqualTo: loggedInUser.uid)
                                  .where('status', isEqualTo: "Accepted")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final numberOfSchoolRequest =
                                      snapshot.data!.docs;
                                  if (numberOfSchoolRequest.isEmpty) {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kAGreen,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'Accepted',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kAGreen,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'Accepted',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                      Row(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chapterRequest')
                                  //.where('schUid', isEqualTo: loggedInUser.uid)
                                  .where('status', isEqualTo: "Declined")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final numberOfSchoolRequest =
                                      snapshot.data!.docs;
                                  if (numberOfSchoolRequest.isEmpty) {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kARed,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'Declined',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfSchoolRequest.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kARed,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'Declined',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ChapterRequestTab()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kADarkBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          height: 32.0,
                          child: Text(
                            "Review",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: "Rajdhani",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CreateSchoolChapter()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kADarkBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          height: 32.0,
                          child: Text(
                            "Create New",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: "Rajdhani",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              child: Container(
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset("images/alumni/portfolio.svg"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        child: Text(
                          "JOBS",
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: kAOrangeRed),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('AlumniJobs')
                                  //.where('uid', isEqualTo: loggedInUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final jobsListed = snapshot.data!.docs;
                                  if (jobsListed.isEmpty) {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${jobsListed.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kADarkBlue,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'JobsListed',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${jobsListed.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kADarkBlue,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'JobsListed',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                      Row(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('AlumniJobs')
                                  //.where('schUid', isEqualTo: loggedInUser.uid)
                                  .where('status', isEqualTo: "PersonsApplied")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final numberOfJobsApplied =
                                      snapshot.data!.docs;
                                  if (numberOfJobsApplied.isEmpty) {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfJobsApplied.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kAGreen,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'PersonsApplied',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Badge(
                                        toAnimate: false,
                                        padding: EdgeInsets.all(4.0),
                                        badgeContent: Text(
                                          '${numberOfJobsApplied.length}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeColor: kAGreen,
                                        position: BadgePosition.topStart(
                                            top: -12, start: -14),
                                        child: Text(
                                          'PersonsApplied',
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: kABlack),
                                        ),
                                      ),
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                                          backgroundColor: Colors.redAccent,
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
                                          backgroundColor:
                                              Colors.lightBlueAccent,
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
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: JobsTab()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kADarkBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          height: 32.0,
                          child: Text(
                            "Review",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: "Rajdhani",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CreateJobs()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kADarkBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          height: 32.0,
                          child: Text(
                            "Create New",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: "Rajdhani",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
