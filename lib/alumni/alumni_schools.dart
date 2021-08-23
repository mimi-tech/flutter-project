import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/alumni_schoolinviteinput.dart';
import 'package:sparks/alumni/alumnireg.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/strings.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'color/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alumni extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlumniState();
  }
}

class _AlumniState extends State<Alumni> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.ALUMNI;
  TextEditingController schoolSearchController = TextEditingController();

  bool showSearchCard = false;
  bool showMainCard = true;
  bool? isPressed;
  bool isPending = false;
  bool isSearching = false;

  void checkRequestStatus(status, schoolAccountId) {
    FirebaseFirestore.instance
        .collection('sentSchoolRequest')
        .where('status', isEqualTo: status)
        .where('schAccId', isEqualTo: schoolAccountId)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
    });
  }

  void checkIfRequestExist(schoolId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('sentSchoolRequest')
        .where('uid', isEqualTo: UserStorage.loggedInUser.uid)
        .where('schAccId', isEqualTo: schoolId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length >= 1) {
      Fluttertoast.showToast(
          msg: "Request already sent!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    }
  }

  void initState() {
    super.initState();

    UserStorage.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: kAGrey.withOpacity(0.8),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: SchoolInviteInput()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: isSearching == false
                              ? Text(
                                  "Notify My School",
                                  style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: kADarkGrey,
                                  ),
                                )
                              : TextField(
                                  controller: schoolSearchController,
                                  onChanged: (value) {
                                    value = value.toLowerCase();
                                    if (schoolSearchController.text.length !=
                                        0) {
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
                                    border: InputBorder.none,
                                    icon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "images/alumni/searchbutton.svg",
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: "Find My School",
                                    hintStyle: TextStyle(
                                      color: kAGrey,
                                      fontFamily: "Rajdhani",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
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

                              schoolSearchController.clear();
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
                ],
              ),
            ),
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
                    // final schools = snapshot.data.docs;

                    List<Map<String, dynamic>?> schools =
                        snapshot.data!.docs.map((DocumentSnapshot doc) {
                      return doc.data as Map<String, dynamic>?;
                    }).toList();
                    print(schools);
                    if (schools.isEmpty) {
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
                      for (var school in schools) {
                        checkRequestStatus(
                            school!['status'], school['schAccId']);
                        print(school['logo']);
                        final cardWidget = Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SchoolCards(school: school),
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
        //TODO: for search card functionality
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
                      .contains(schoolSearchController.text.toLowerCase()));
                  if (schools.isEmpty) {
                    return Center(child: Text("No Search Result Found"));
                  } else {
                    List<Widget> cardWidgets = [];
                    for (var school in schools) {
                      Map<String, dynamic> data =
                          school.data() as Map<String, dynamic>;
                      checkRequestStatus(data['status'], data['schAccId']);
                      print(data['logo']);
                      final cardWidget = Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SchoolCards(school: data),
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
    ));
  }
}

class SchoolCards extends StatelessWidget {
  const SchoolCards({
    Key? key,
    required this.school,
  }) : super(key: key);

  // final DocumentSnapshot school;

  final Map<String, dynamic>? school;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: kAWhite,
        height: MediaQuery.of(context).size.height * 0.128,
        width: MediaQuery.of(context).size.width,
        child: Row(children: <Widget>[
          Expanded(
            flex: 8,
            child: Row(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0, top: 23.0, bottom: 0.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: ClipOval(
                        child: Image(
                          image: NetworkImage(school!['logo'] ??
                              "https://image.freepik.com/free-vector/head-man_1308-33466.jpg"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 0.1, right: 0.1, top: 13.0),
                                        child: Image.asset(
                                            "images/alumni/Group_1.png"),
                                        height: 18.0,
                                        width: 18.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 17.0, left: 5.0),
                                        child: Text(
                                          ReusableFunctions.capitalize(
                                              school!['name']),
                                          style: TextStyle(
                                              color: kADarkBlue,
                                              fontFamily: 'Rajdhani',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 0.1, top: 1.0, bottom: 8.0),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 20.0,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5.0, left: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              school!['street'] ?? "Akwukwuma",
                                              style: TextStyle(
                                                  fontFamily: 'Rajdhani',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                            Text(
                                              school!['city'] ?? "Uche",
                                              style: TextStyle(
                                                  color: Colors.brown,
                                                  fontFamily: 'Rajdhani',
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ]),
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
                  final QuerySnapshot result = await FirebaseFirestore.instance
                      .collection('sentSchoolRequest')
                      .where('uid', isEqualTo: UserStorage.loggedInUser.uid)
                      .where('schAccId', isEqualTo: school!['sch_id'])
                      .get();
                  final List<DocumentSnapshot> documents = result.docs;

                  if (documents.length >= 1) {
                    Fluttertoast.showToast(
                        msg: "Request already sent!",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else {
                    SchoolStorage.schoolId = school!['sch_id'] ?? "Uche";
                    SchoolStorage.userId = school!['uid'] ?? "Uche";
                    SchoolStorage.schoolName = school!['name'] ?? "Uche";
                    SchoolStorage.logo = school!['logo'] ?? "Uche";
                    SchoolStorage.un = school!['un'] ?? "Uche";
                    SchoolStorage.phn = school!['phn'] ?? "Uche";
                    SchoolStorage.street = school!['street'] ?? "Uche";
                    SchoolStorage.state = school!['state'] ?? "Uche";
                    SchoolStorage.email = school!['email'] ?? "Uche";
                    SchoolStorage.city = school!['city'] ?? "Uche";
                    SchoolStorage.adr = school!['adr'] ?? "Uche";
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SignIn()));
                  }
                },
                splashColor: kAWhite,
                child: Text(
                  school!['status'] == "pending" ? "Pending" : kAppBarJoin,
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
        ]),
      ),
    );
  }
}
