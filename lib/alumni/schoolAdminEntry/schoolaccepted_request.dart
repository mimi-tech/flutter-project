import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/alumni/color/colors.dart';

class SchoolAcceptedRequest extends StatefulWidget {
  @override
  _SchoolAcceptedRequestState createState() => _SchoolAcceptedRequestState();
}

class _SchoolAcceptedRequestState extends State<SchoolAcceptedRequest> {
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
                  //.where('schUid', isEqualTo: sparksUser.uid)
                  .where('status', isEqualTo: "Accepted")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final schoolRequests = snapshot.data.docs;

                  List<Map<String, dynamic>> schoolRequests =
                      snapshot.data!.docs.map((doc) {
                    return doc.data as Map<String, dynamic>;
                  }).toList();
                  if (schoolRequests.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                    for (var schoolRequest in schoolRequests) {
                      final cardWidget = Card(
                        elevation: 10.0,
                        color: kAWhite,
                        child: Row(children: <Widget>[
                          Container(
                            color: kAWhite,
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.width * 0.975,
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
                                          backgroundColor: Colors.transparent,
                                          radius: 32,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: schoolRequest['logo'] ??
                                                  "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                  flex: 37,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10.0, left: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  schoolRequest['name'] ??
                                                      "uche",
                                                  style: TextStyle(
                                                      fontFamily: 'Rajdhani',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 21.0),
                                                ),
                                                Text(
                                                  schoolRequest['grade'] ??
                                                      "uche",
                                                  style: TextStyle(
                                                      fontFamily: 'Rajdhani',
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  schoolRequest['schName'] ??
                                                      "uche",
                                                  style: TextStyle(
                                                      fontFamily: 'Rajdhani',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          schoolRequest[
                                                                  "stYr"] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Text(" - "),
                                                      Container(
                                                        child: Text(
                                                          schoolRequest[
                                                                  "edYr"] ??
                                                              "uche",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 73.0, right: 3.0),
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
                                      child: Text(
                                        "make admin",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: kAWhite,
                                            fontFamily: "Rajdhani",
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
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
                          backgroundColor: Colors.deepOrangeAccent,
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
