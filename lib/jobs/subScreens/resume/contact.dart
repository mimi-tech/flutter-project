import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/referenceComponent.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/edit/about.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  void initState() {
    super.initState();
    ProfessionalStorage.resume = FirebaseFirestore.instance
        .collection('professionals')
        .doc(ProfessionalStorage.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    return new StreamBuilder(
        stream: ProfessionalStorage.resume,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          Map<String, dynamic> resumeDetails =
              snapshot.data as Map<String, dynamic>;

          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    height: screenData.height * 0.77,
                    width: screenData.width * 0.98,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: kBackgroundColor,
                          ),
                          height: screenData.height * 0.69,
                          width: screenData.width * 0.97,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                  child: Text(
                                    ReusableFunctions.capitalizeWords(
                                        resumeDetails["name"])!,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: kAboutMiddleTextColor4),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                  //color: Colors.red,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 82,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: resumeDetails["imageUrl"],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: ScreenUtil().setHeight(500.0),
                                        width: ScreenUtil().setWidth(500),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                  child: Text(
                                    resumeDetails["pTitle"],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(16.0),
                                          fontWeight: FontWeight.bold,
                                          color: kAddress),
                                    ),
                                  ),
                                ),
                                ContactPE(
                                  title: "Location: ",
                                  content: ReusableFunctions.capitalizeWords(
                                      resumeDetails["location"]),
                                ),
                                ContactPE(
                                  title: "Phone: ",
                                  content: resumeDetails["phone"],
                                ),
                                ContactPE(
                                  title: "Email@: ",
                                  content: resumeDetails["email"],
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (ProfessionalStorage.isLoggedInUser(
                                              UserStorage.loggedInUser.uid,
                                              ProfessionalStorage.id) ==
                                          true) {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: EditAbout()));
                                      } else {
                                        UserStorage.fromResume = true;
                                        ProfessionalStorage.email =
                                            resumeDetails["email"];
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: Jobs()));
                                      }
                                    },
                                    color: kLight_orange,
                                    child: Text(
                                      ProfessionalStorage.isLoggedInUser(
                                              UserStorage.loggedInUser.uid,
                                              ProfessionalStorage.id)
                                          ? 'EDIT'
                                          : "Employ Me",
                                    ),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
