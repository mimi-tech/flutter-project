import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenOne.dart';

class JobDetails extends StatefulWidget {
  @override
  _JobDetails createState() => _JobDetails();
}

class _JobDetails extends State<JobDetails> {
  bool profState = false;
  bool jobState = true;

  var singleJobDocument;
  bool show = false;

  double? starRating = 0.0;

  String name =
      "${GlobalVariables.loggedInUserObject.nm!["fn"]} ${GlobalVariables.loggedInUserObject.nm!["ln"]}";

  void checkIfJobIsOpen(jobId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('companyJobs')
        .where('id', isEqualTo: jobId)
        .where('status', isEqualTo: "closed")
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length >= 1) {
      setState(() {
        jobState = false;
      });
    }
  }

  void checkIfResumeExit() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('professionals')
        .where('userId', isEqualTo: UserStorage.loggedInUser.uid)
        .get();
    // final List<DocumentSnapshot> documents = result.docs;

    List<Map<String, dynamic>?> documents =
        result.docs.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    if (documents.length >= 1) {
      print("hello world here");
      print(documents[0]!["avgRt"]);
      setState(() {
        profState = true;
        starRating = documents[0]!["avgRt"];
      });
    }
  }

  var date = DateTime.now().toString();

  void checkIfUserHasApplied(companyId, singleJobId) async {
    print(jobState);
    if (jobState == false) {
      Fluttertoast.showToast(
          msg: "Sorry Application Closed ",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (profState == false) {
      Fluttertoast.showToast(
          msg: "Please Create Job Profile",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: CreateProfessionalScreenOne()));
    } else {
      setState(() {
        show = true;
      });
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('appliedJobs')
          .doc(companyId)
          .collection('jobsApplied')
          .doc(PostJobFormStorage.jobId)
          .collection('jobDetails')
          .where('uid', isEqualTo: UserStorage.loggedInUser.uid)
          .where('email', isEqualTo: UserStorage.loggedInUser.email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length >= 1) {
        setState(() {
          show = false;
        });
        Fluttertoast.showToast(
            msg: "Sorry You Have Applied For This Job",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        print(starRating);
        try {
          setState(() {
            show = true;
          });
          FirebaseFirestore.instance
              .collection('appliedJobs')
              .doc(PostJobFormStorage.companyId)
              .collection("jobsApplied")
              .doc(PostJobFormStorage.jobId)
              .collection('jobDetails')
              .add({
            'email': UserStorage.loggedInUser.email,
            'nm': name,
            'jtl': PostJobFormStorage.jobTitle,
            'jtp': PostJobFormStorage.jobType,
            'jcg': PostJobFormStorage.jobCategory,
            'lur': PostJobFormStorage.logoUrl,
            'uid': UserStorage.loggedInUser.uid,
            'date': date,
            'avgRt': starRating,
            'jobId': singleJobId,
            'cid': PostJobFormStorage.companyId,
            'time': DateTime.now()
          });

          setState(() {
            show = false;
          });
          Fluttertoast.showToast(
              msg: "job applied successfully",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black,
              textColor: Colors.white);
          Navigator.pop(context);
        } catch (err) {
          print(err);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfJobIsOpen(PostJobFormStorage.jobId);
    checkIfResumeExit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(true),
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.7,
                  automaticallyImplyLeading: true,
                  backgroundColor: kLight_orange,
                  centerTitle: true,
                  title: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      'Apply for this job',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                body: ModalProgressHUD(
                  inAsyncCall: show,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                              child: Text(
                                PostJobFormStorage.companyName!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(25.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      10.0, 15.0, 0.0, 15.0),
                                  height: ScreenUtil().setHeight(70.0),
                                  width: ScreenUtil().setWidth(70),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 72,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: PostJobFormStorage.logoUrl!,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Text(
                                PostJobFormStorage.jobTitle!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(20.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                              child: Text(
                                PostJobFormStorage.jobLocation!,
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
                                "Salary \$${PostJobFormStorage.salaryRangeMin}, - \$${PostJobFormStorage.salaryRangeMax}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(16.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                              child: Text(
                                "${PostJobFormStorage.jobCategory}, - ${PostJobFormStorage.jobType}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(16.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),

                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                              child: Text(
                                "JOB SUMMARY",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(14.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),

                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              child: Text(
                                PostJobFormStorage.jobSummary!,
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
                                    "RESPONSIBILITIES",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(20.0),
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
                                      in PostJobFormStorage.responsibility!)
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
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "SKILLS",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(20.0),
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
                                  for (var item in PostJobFormStorage.skills!)
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
                                    "QUALIFICATIONS",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(20.0),
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
                                      in PostJobFormStorage.jobQualification!)
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
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "JOB BENEFITS",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(20.0),
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
                                      in PostJobFormStorage.jobBenefit!)
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

                            RaisedButton(
                              onPressed: () {
                                checkIfUserHasApplied(
                                    PostJobFormStorage.companyId,
                                    PostJobFormStorage.jobId);
                              },
                              color: kLight_orange,
                              textColor: Colors.white,
                              child: Text(
                                'APPLY',
                              ),
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ))));
  }
}
