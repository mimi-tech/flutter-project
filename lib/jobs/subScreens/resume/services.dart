import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/edit/serivices.dart';

class Services extends StatefulWidget {
  const Services({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
          EditProfessionalStorage.services = resumeDetails["services"];
          EditProfessionalStorage.id = resumeDetails['userId'];

          return SafeArea(
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (var i = 0; i < resumeDetails["services"].length; i++)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Card(
                          elevation: 15,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: ScreenUtil().setWidth(390.0),
                                    minHeight: ScreenUtil().setHeight(100.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                        ),
                                        width: ScreenUtil().setWidth(390.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0.0, 20.0, 0.0, 20.0),
                                              child: Text(
                                                resumeDetails["services"][i]
                                                    ['title'],
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(25.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kLight_orange),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 0.0, 10.0, 25.0),
                                              child: ReadMoreText(
                                                resumeDetails["services"][i]
                                                    ['description'],
                                                trimLines: 6,
                                                colorClickableText:
                                                    kLight_orange,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText:
                                                    ' ...Show more',
                                                trimExpandedText:
                                                    ' ...Show less',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
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
                                                child: EditServices()));
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
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: RaisedButton(
                                    onPressed: () {
                                      widget.tabController!.animateTo(3);
                                    },
                                    color: kLight_orange,
                                    child: Text(
                                      "view my work",
                                    ),
                                    textColor: Colors.white,
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
            ),
          );
        });
  }
}
