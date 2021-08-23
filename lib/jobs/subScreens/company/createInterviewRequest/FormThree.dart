import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class InterviewFormThree extends StatefulWidget {
  const InterviewFormThree({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;
  @override
  _InterviewFormThreeState createState() => _InterviewFormThreeState();
}

class _InterviewFormThreeState extends State<InterviewFormThree> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  //TODO: function to upload company interview request
  void uploadInterviewRequest() {
    setState(() {
      showSpinner = true;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('interviewRequest')
        .doc(UserStorage.loggedInUser.uid)
        .collection('companyInterviewsPages')
        .doc(CompanyStorage.pageId)
        .collection('companyInterviewDetails')
        .doc();
    documentReference.set({
      'cid': CompanyStorage.pageId,
      'cnm':
          ReusableFunctions.capitalizeWords(InterviewFormStorage.companyName),
      'jbt': InterviewFormStorage.jobBenefit,
      'ims': InterviewFormStorage.interviewMessage,
      'jdt': InterviewFormStorage.description,
      'jtl': InterviewFormStorage.jobTitle,
      'cpd': InterviewFormStorage.contactPerson,
      'jlt':
          ReusableFunctions.capitalizeWords(InterviewFormStorage.jobLocation),
      'jrm': InterviewFormStorage.jobRequirement,
      'ivn': ReusableFunctions.capitalizeWords(
          InterviewFormStorage.interviewVenue),
      'jtm': DateTime.now().toString(),
      'lur': InterviewFormStorage.logoUrl,
      'srn': InterviewFormStorage.salaryRangeMin,
      'srx': InterviewFormStorage.salaryRangeMax,
      'user': UserStorage.loggedInUser.email,
      'mainId': UserStorage.loggedInUser.uid,
      'id': documentReference.id,
      'time': DateTime.now()
    });
    Fluttertoast.showToast(
        msg: "Interview Request Created Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white);

    setState(() {
      showSpinner = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(true),
        child: Container(
            child: SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: ModalProgressHUD(
                      inAsyncCall: showSpinner,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  InterviewFormStorage.companyName!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(25.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              child: Text(
                                InterviewFormStorage.jobTitle!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(20.0),
                                      fontWeight: FontWeight.bold,
                                      color: kNavBg),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                              child: Text(
                                InterviewFormStorage.jobLocation!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                              child: Text(
                                InterviewFormStorage.description!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(14.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                              child: Text(
                                "Salary \$${InterviewFormStorage.salaryRangeMin} - \$${InterviewFormStorage.salaryRangeMax}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18.0),
                                      fontWeight: FontWeight.bold,
                                      color: kNavBg),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              child: Text(
                                InterviewFormStorage.interviewMessage!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(14.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),

                            //for requirment
                            Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Requirements",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                              child: Column(
                                children: <Widget>[
                                  for (var item
                                      in InterviewFormStorage.jobRequirement!)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/bullet.svg",
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item,
                                                softWrap: true,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(14.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            //for benefits
                            Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Benefits",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                              child: Column(
                                children: <Widget>[
                                  for (var item
                                      in InterviewFormStorage.jobBenefit!)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/bullet.svg",
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item,
                                                softWrap: true,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(14.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            Container(
                                margin:
                                    EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                                child: Column(
                                  children: <Widget>[
                                    for (var i = 0;
                                        i <
                                            InterviewFormStorage
                                                .contactPerson!.length;
                                        i++)
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15.0, 30.0, 0.0, 5.0),
                                            child: Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.account_circle,
                                                      color: kLight_orange,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Contact Person ${i + 1}",
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(20.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ExContent(
                                            dString: "images/jobs/dm.png",
                                            text1: InterviewFormStorage
                                                .contactPerson!
                                                .elementAt(i)['name'],
                                            text2: InterviewFormStorage
                                                .contactPerson!
                                                .elementAt(i)['role'],
                                            text3: InterviewFormStorage
                                                .contactPerson!
                                                .elementAt(i)['phone'],
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                  ],
                                )),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    widget.tabController!.animateTo(1);
                                  },
                                  color: kLight_orange,
                                  textColor: Colors.white,
                                  child: Text("previous"),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    uploadInterviewRequest();
                                  },
                                  color: kLight_orange,
                                  textColor: Colors.white,
                                  child: Text("create"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}
