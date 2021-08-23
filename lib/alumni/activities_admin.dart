import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/strings.dart';
import 'color/colors.dart';

class ActivitiesAdmin extends StatefulWidget {
  @override
  _ActivitiesAdminState createState() {
    return _ActivitiesAdminState();
  }
}

class _ActivitiesAdminState extends State<ActivitiesAdmin> {
  TextEditingController _adminSearchController = TextEditingController();

  bool isSearching = false;
  bool showSearchCard = false;
  bool showMainCard = true;

  @override
  void initState() {
    super.initState();
    _adminSearchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    _adminSearchController.removeListener(onSearchChanged);
    _adminSearchController.dispose();
    super.dispose();
  }

  onSearchChanged() {
    print(_adminSearchController.text);
  }

  List<String> uche = [
    KAppBarMembers,
    KAppBarMySet,
    KAppBarChapter,
    KAppBarAdmin,
  ];

  int _value = 0;
  var selectedValue = 0;
  var isLargeScreen = false;

  void checkRequestStatus(status, schoolAccountId) {
    FirebaseFirestore.instance
        .collection('adminList')
        .where('status', isEqualTo: status)
        .where('schAccId', isEqualTo: schoolAccountId)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
          ),
          child: TextField(
            controller: _adminSearchController,
            onChanged: (value) {
              value = value.toLowerCase();
              if (_adminSearchController.text.length != 0) {
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
            decoration: InputDecoration(
                hintText: "search admin",
                hintStyle: TextStyle(
                  color: kAGrey,
                  fontFamily: "Rajdhani",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.search_sharp)),
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
                    _adminSearchController.clear();
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
                    .collectionGroup('schoolUsers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // final admins = snapshot.data.docs;

                    List<Map<String, dynamic>?> admins = snapshot.data!.docs.map((DocumentSnapshot doc) {
                      return doc.data as Map<String, dynamic>?;
                    }).toList();
                    print(admins);
                    if (admins.isEmpty) {
                      return Text(
                        "No Schools Available",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kAWhite,
                        ),
                      );
                    } else {
                      List<Widget> cardWidgets = [];
                      for (var admin in admins) {
                        checkRequestStatus(
                            admin!['status'], admin['schAccId']);
                        print(admin['logo']);
                        final cardWidget = Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: AdminCards(schoolRequest: admin),
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
                  .collectionGroup('schoolUsers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final schools = snapshot.data!.docs.where((a) => a['name']
                      .contains(_adminSearchController.text.toLowerCase()));

                  if (schools.isEmpty) {
                    return Center(child: Text("No Search Result Found"));
                  } else {
                    List<Widget> cardWidgets = [];
                    for (var admin in schools) {
                      Map<String, dynamic> data = admin as Map<String, dynamic>;
                      checkRequestStatus(
                          data['status'], data['schAccId']);
                      print(data['logo']);
                      final cardWidget = Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: AdminCards(schoolRequest: data),
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
    )));
  }
}

class AdminCards extends StatelessWidget {
  const AdminCards({
    Key? key,
    required this.schoolRequest,
  }) : super(key: key);

  // final DocumentSnapshot schoolRequest;
  final Map<String, dynamic>? schoolRequest;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Container(
        color: kAWhite,
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width * 0.98,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 13, 0, 0),
                          child: CachedNetworkImage(
                            imageUrl: schoolRequest!['logo'] ??
                                "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: kADeepOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
                          alignment: Alignment.center,
                          height: 20,
                          width: 40,
                          child: Text(
                            "Profile",
                            style: new TextStyle(
                              color: kAWhite,
                              fontSize: 12.0,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            Flexible(
              flex: 38,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0, left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              schoolRequest!['name'] ?? "school",
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0),
                            ),
                            Text(
                              schoolRequest!['grade'] ?? "school",
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              schoolRequest!['schName'] ?? "school",
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      schoolRequest!["stYr"] ?? "school",
                                      style: TextStyle(
                                          fontFamily: 'Rajdhani',
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(" - "),
                                  Container(
                                    child: Text(
                                      schoolRequest!["edYr"] ?? "school",
                                      style: TextStyle(
                                          fontFamily: 'Rajdhani',
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
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
              flex: 6,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 5, 0),
                  width: 30.03,
                  height: 28.09,
                  child: Image.asset("images/alumni/messages.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
