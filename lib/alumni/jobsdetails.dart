import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sparks/Alumni/apply-jobs.dart';
import 'package:sparks/alumni/color/colors.dart';

class JobsDetails extends StatefulWidget {
  @override
  _JobsDetailsState createState() => _JobsDetailsState();
}

class _JobsDetailsState extends State<JobsDetails> {
  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;

  bool val = false;

  onSwitchValueChanged(bool newVal) {
    setState(() {
      val = newVal;
    });
  }

  void checkJobsStatus(status, schoolAccountId) {
    FirebaseFirestore.instance
        .collection('jobsApplied')
        .where('status', isEqualTo: status)
        .where('schAccId', isEqualTo: schoolAccountId)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kADarkRed,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 65.0),
                child: Text(
                  "Software Developer",
                  style: TextStyle(
                    fontFamily: "Rajdhani",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'images/Alumni/HAVARD.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Google LLc",
                          style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Software Developer",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Full-time",
                                style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: kABlack),
                              ),
                            ),
                            Text(
                              "NGN2,000 - 15,000/month",
                              style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Baltimore,Md Usa",
                                style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: kABlack),
                              ),
                            ),
                            Text(
                              "Jan 8,2020 - Jan 2,2020",
                              style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kADeepOrange,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        "Job Description",
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: kADarkBlue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "A job description is an internal document that clearly states the essential job requirements, job duties, job responsibilities, and skills required to perform a specific role. A more detailed job description will cover how success is measured in the role so it can be used during performance evaluations."),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: kAGrey,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Job created by :",
                                style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: kADarkBlue),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/Alumni/pic1.png'),
                                    backgroundColor: kAWhite,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    "Google llc",
                                    style: TextStyle(
                                      fontFamily: "Rajdhani",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: kAGrey,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: SvgPicture.asset("images/Alumni/lov1.svg"),
                            ),
                            Container(
                              child: Text(
                                "Sparkup",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child:
                                  SvgPicture.asset("images/Alumni/chat21.svg"),
                            ),
                            Container(
                              child: Text(
                                "Comment",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
            Container(
              height: 40.0,
              width: double.infinity,
              child: RaisedButton(
                elevation: 15,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Apply()));
                },
                color: kADeepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "APPLY NOW",
                        style: TextStyle(
                            color: kAWhite,
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
