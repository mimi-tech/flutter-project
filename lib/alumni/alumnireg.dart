import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/strings.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final TextEditingController studentName = TextEditingController();
  final TextEditingController studentGradeOrLevel = TextEditingController();
  final TextEditingController studentStartYear = TextEditingController();
  final TextEditingController studentEndYear = TextEditingController();
  final TextEditingController studentSchoolIdNumber = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late User loggedInUser;
  bool showSpinner = false;
  bool isRequestSent = false;

  void getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        checkIfRequestExist();
      }
    } catch (e) {
      print(e);
    }
  }

  void checkIfRequestExist() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('sentSchoolRequest')
        .where('uid', isEqualTo: loggedInUser.uid)
        .where('schAccId', isEqualTo: SchoolStorage.schoolId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length >= 1) {
      setState(() {
        isRequestSent = true;
      });
      Fluttertoast.showToast(
          msg: "Request already sent!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
      Navigator.pop(context);
    }
  }

  void sendSchoolRequest(uid) {
    //TODO:validate input data
    if (studentName.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (studentGradeOrLevel.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (studentStartYear.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (studentEndYear.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (studentSchoolIdNumber.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else {
      //TODO: send to database

      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('sentSchoolRequest')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'schUid': SchoolStorage.userId,
        'id': documentReference.id,
        'schAccId': SchoolStorage.schoolId,
        'schName': SchoolStorage.schoolName,
        'logo': SchoolStorage.logo,
        'adr': SchoolStorage.adr,
        'email': SchoolStorage.email,
        "city": SchoolStorage.city,
        'state': SchoolStorage.state,
        'street': SchoolStorage.street,
        'phn': SchoolStorage.phn,
        'un': SchoolStorage.un,
        'name': studentName.text,
        'grade': studentGradeOrLevel.text,
        "stYr": studentStartYear.text,
        "edYr": studentEndYear.text,
        'stdId': studentSchoolIdNumber.text,
        'status': 'pending',
        'uid': uid,
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "REQUEST SENT",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
      SchoolStorage.isItFromSchoolRequest = true;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kADarkRed,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40.0),
            child: Text(
              SchoolStorage.schoolName!,
              style: TextStyle(
                fontFamily: "Rajdhani",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentName,
                        decoration: InputDecoration(
                            hintText: "enter your name",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: kAppBarName,
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentGradeOrLevel,
                        decoration: InputDecoration(
                            hintText: "enter grade or level",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: "Grade or Level",
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentStartYear,
                        decoration: InputDecoration(
                            hintText: "enter start year",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: "Start Year",
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentEndYear,
                        decoration: InputDecoration(
                            hintText: "enter end year",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: "End Year",
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentSchoolIdNumber,
                        decoration: InputDecoration(
                            hintText: "enter your school ID number",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: kAppBarSchoolIDNumber,
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(50.0),
                      height: 49.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: RaisedButton(
                        elevation: 10.0,
                        color: kADeepOrange,
                        onPressed: () {
                          sendSchoolRequest(loggedInUser.uid);
                        },
                        splashColor: kAWhite,
                        child: Text(
                          "Send",
                          style: TextStyle(
                              color: kAWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: "Rajdhani"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
