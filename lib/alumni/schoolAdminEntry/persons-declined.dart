import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import '../strings.dart';

class PersonsDeclined extends StatefulWidget {
  @override
  _PersonsDeclinedState createState() => _PersonsDeclinedState();
}

class _PersonsDeclinedState extends State<PersonsDeclined> {
  @override
  Widget build(BuildContext context) {
    final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AppointmentRequest')
                  .where('schUid', isEqualTo: sparksUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final schoolRequests = snapshot.data.docs;
                  List<Map<String, dynamic>> schoolRequests =
                      snapshot.data!.docs.map((doc) {
                    return doc.data as Map<String, dynamic>;
                  }).toList();
                  if (schoolRequests.isEmpty) {
                    return Container(
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
                    );
                  } else {
                    List<Widget> cardWidgets = [];
                    for (Map<String, dynamic> schoolRequest in schoolRequests) {
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
                                        0.90,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 9,
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
                                                      imageUrl:
                                                          schoolRequest['logo'],
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
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    left: 7.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: kAOrangeRed,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6.0))),
                                                  alignment: Alignment.center,
                                                  height: 21,
                                                  width: 50,
                                                  child: Text(
                                                    "Profile",
                                                    style: new TextStyle(
                                                      color: kAWhite,
                                                      fontSize: 14.0,
                                                      fontFamily: 'Rajdhani',
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          schoolRequest['name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 21.0),
                                                        ),
                                                        Text(
                                                          schoolRequest[
                                                              'grade'],
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
                                                              'schName'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rajdhani',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0),
                                                        ),
                                                        Text(
                                                          schoolRequest['year'],
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          DocumentReference documentReference =
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'AppointmentRequest')
                                                  .doc(schoolRequest['id']);
                                          documentReference
                                              .update({'status': "Accepted"});
                                          Fluttertoast.showToast(
                                              msg: "Request Accepted",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.green,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              textColor: Colors.white);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 2.0, right: 2.0),
                                          decoration: BoxDecoration(
                                              color: kAGreen,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0))),
                                          alignment: Alignment.center,
                                          height: 24,
                                          width: 61,
                                          child: Text(
                                            "Accept",
                                            style: new TextStyle(
                                              color: kAWhite,
                                              fontSize: 17.0,
                                              fontFamily: 'Rajdhani',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                                Container(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          DocumentReference documentReference =
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'AppointmentRequest')
                                                  .doc(schoolRequest['id']);

                                          documentReference
                                              .update({'status': "Declined"});
                                          Fluttertoast.showToast(
                                              msg: "Request Declined",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.red,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              textColor: Colors.white);
                                          SchoolStorage.reAcceptId =
                                              schoolRequest['id'];
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 2.0, right: 2.0),
                                          decoration: BoxDecoration(
                                              color: kAGrey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0))),
                                          alignment: Alignment.center,
                                          height: 24,
                                          width: 61,
                                          child: Text(
                                            "Decline",
                                            style: new TextStyle(
                                              color: kAWhite,
                                              fontSize: 17.0,
                                              fontFamily: 'Rajdhani',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
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
