import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/alumni/color/colors.dart';

class AlumniSchoolPending extends StatefulWidget {
  @override
  _AlumniSchoolPendingState createState() => _AlumniSchoolPendingState();
}

class _AlumniSchoolPendingState extends State<AlumniSchoolPending> {
  //User loggedInUser;
  Color changeStatusColor(status) {
    if (status == "pending") {
      return Colors.grey;
    } else if (status == "Accepted") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      body: ListView(
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
                  // final schoolRequests = snapshot.data.docs;

                  List<Map<String, dynamic>?> schoolRequests =
                      snapshot.data!.docs.map((DocumentSnapshot doc) {
                    return doc.data as Map<String, dynamic>?;
                  }).toList();
                  if (schoolRequests.isEmpty) {
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
                            "No Pending Request",
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
                    for (var schoolRequest in schoolRequests) {
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
                                        0.14,
                                    width: MediaQuery.of(context).size.width *
                                        0.98,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10.0, bottom: 0.0),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 32,
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl: schoolRequest![
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
                                          flex: 25,
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
                                                          schoolRequest[
                                                                  'schName'] ??
                                                              "school",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 19.0),
                                                        ),
                                                        Text(
                                                          schoolRequest[
                                                                  'street'] ??
                                                              "school",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          schoolRequest[
                                                                  'city'] ??
                                                              "school",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 7,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                1, 60, 0, 0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                bottomRight: Radius.circular(4),
                                              )),
                                              onPressed: () {},
                                              child: Text(
                                                "Pending",
                                                style: TextStyle(
                                                  fontFamily: "Rajdhani",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: kAWhite,
                                                ),
                                              ),
                                              color: changeStatusColor(
                                                  schoolRequest['status']),
                                            ),
                                          ),
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
