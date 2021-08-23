import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/entry.dart';
import 'package:sparks/jobs/subScreens/company/admin/interview/entry.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/entry.dart';
import 'package:sparks/jobs/subScreens/company/createAppointmentLetter/entry.dart';
import 'package:sparks/jobs/subScreens/company/createInterviewRequest/createInterviewEntry.dart';
import 'package:sparks/jobs/subScreens/company/createJobOffers/createJobOfferEntry.dart';
import 'package:sparks/jobs/subScreens/company/createJobs/screenOne.dart';
import 'package:sparks/market/components/badge_counter.dart';

import 'jobs/entry.dart';
import 'package:google_fonts/google_fonts.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  Stream? _stream;

  String numberOfJobs = "No Jobs Listed";
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    //clear interview storage
    InterviewFormStorage.companyName = null;
    InterviewFormStorage.jobBenefit = [];
    InterviewFormStorage.interviewMessage = null;
    InterviewFormStorage.jobRequirement = [];
    InterviewFormStorage.jobLocation = null;
    InterviewFormStorage.jobTitle = null;
    InterviewFormStorage.description = null;
    InterviewFormStorage.interviewVenue = null;
    InterviewFormStorage.salaryRangeMin = null;
    InterviewFormStorage.salaryRangeMax = null;
    InterviewFormStorage.logoName = null;
    InterviewFormStorage.companyLogo = null;
    InterviewFormStorage.contactPerson = [];
    InterviewFormStorage.logoUrl = null;
    InterviewFormStorage.jobTime = null;
    InterviewFormStorage.jobId = null;
    InterviewFormStorage.mainCompanyId = null;

    _stream = FirebaseFirestore.instance
        .collection('users')
        .doc(CompanyStorage.companyId)
        .collection('company')
        .doc(CompanyStorage.pageId)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: ScreenUtil().setSp(110),
                                minHeight: ScreenUtil().setSp(2)),
                            child: Text(
                              "Loading",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(10.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Admin',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: BadgeCounter(
                                  badgeText: '120',
                                  iconData: Icons.notifications_none,
                                  showBadge: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  titleSpacing: 0.0,
                  backgroundColor: kLight_orange,
                  automaticallyImplyLeading: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        15.0,
                      ),
                      bottomRight: Radius.circular(
                        15.0,
                      ),
                    ),
                  ),
                  actions: <Widget>[],
                ),
                body: Center(
                  child: Text("Loading..."),
                ));
          }
          Map<String, dynamic> companyPage =
              snapshot.data as Map<String, dynamic>;
          CompanyStorage.companyName = companyPage['name'];

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: companyPage['logo'],
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
                      Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil().setSp(110),
                              minHeight: ScreenUtil().setSp(2)),
                          child: Text(
                            companyPage['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(14.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Admin',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: BadgeCounter(
                                badgeText: '120',
                                iconData: Icons.notifications_none,
                                showBadge: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                titleSpacing: 0.0,
                backgroundColor: kLight_orange,
                automaticallyImplyLeading: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      15.0,
                    ),
                    bottomRight: Radius.circular(
                      15.0,
                    ),
                  ),
                ),
                actions: <Widget>[],
              ),
              body: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 6,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ScreenUtil().setHeight(100.0),
                              ),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          25.0, 25.0, 25.0, 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  '10',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(16.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Customers',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(18.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  '25',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(16.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Followers',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(18.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  '99%',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(16.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Reputation',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(18.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kAdmin),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          30.0, 0.0, 30.0, 20.0),
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push (
                                        //     context,
                                        //     PageTransition (
                                        //         type: PageTransitionType.rightToLeft,
                                        //         child: CompanyCreateFive ()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        height: ScreenUtil().setHeight(60.0),
                                        width: ScreenUtil().setWidth(280.0),
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 5.0, 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Manage Jobs Recruitment',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(22.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
// for jobs card
                          Card(
                            elevation: 6,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ScreenUtil().setHeight(100.0),
                              ),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/bag.svg",
                                            height:
                                                ScreenUtil().setHeight(30.0),
                                            width: ScreenUtil().setWidth(30.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'JOBS',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(18.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: kNavBg),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('jobs')
                                                          .doc(UserStorage
                                                              .loggedInUser.uid)
                                                          .collection(
                                                              'companyJobs')
                                                          .where('cid',
                                                              isEqualTo:
                                                                  CompanyStorage
                                                                      .pageId)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final numberOfJobsListed =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (numberOfJobsListed
                                                              .isEmpty) {
                                                            return Text(
                                                                'Jobs Listed(${numberOfJobsListed.length})',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Jobs Listed(${numberOfJobsListed.length})',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collectionGroup(
                                                              'jobDetails')
                                                          .where("cid",
                                                              isEqualTo:
                                                                  CompanyStorage
                                                                      .pageId)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final numberOfAppliedJobs =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (numberOfAppliedJobs
                                                              .isEmpty) {
                                                            return Text(
                                                                'Applicants(${numberOfAppliedJobs.length})',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Applicants(${numberOfAppliedJobs.length})',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child: AdminJobsEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Review"),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                          CreateJobsScreenOne()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Create New"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //for interview request card
                          Card(
                            elevation: 6,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ScreenUtil().setHeight(100.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('interviewRequest')
                                            .doc(CompanyStorage.companyId)
                                            .collection(
                                                'companyInterviewsPages')
                                            .doc(CompanyStorage.pageId)
                                            .collection(
                                                'companyInterviewDetails')
                                            .orderBy('time', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final interviewRequests =
                                                snapshot.data!.docs;
                                            if (interviewRequests.isEmpty) {
                                              return Text(
                                                  '${interviewRequests.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            } else {
                                              return Text(
                                                  '${interviewRequests.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            }
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            print('waiting');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            print('has error');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            print('nothing');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 5.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/inperson.svg",
                                            height:
                                                ScreenUtil().setHeight(30.0),
                                            width: ScreenUtil().setWidth(30.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'JOB INTERVIEW REQUESTS',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(18.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: kNavBg),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sentInterviewRequests')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'sentCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'sentInterviewDetails')
                                                          .orderBy('time',
                                                              descending: true)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final sentInterviewRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (sentInterviewRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Sent[${sentInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Sent[${sentInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.green,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'AcceptedInterviewRequests')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'AcceptedCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'AcceptedInterviewDetails')
                                                          .orderBy('time',
                                                              descending: true)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final acceptedInterviewRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (acceptedInterviewRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Accepted[${acceptedInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Accepted[${acceptedInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: kShade,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'DeclinedInterviewRequests')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'DeclinedCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'DeclinedInterviewDetails')
                                                          .orderBy('time',
                                                              descending: true)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final declinedInterviewRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (declinedInterviewRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Declined[${declinedInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Declined[${declinedInterviewRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          AdminInterviewEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Review"),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              InterviewFormStorage.companyName =
                                                  companyPage['name'];
                                              InterviewFormStorage.jobLocation =
                                                  companyPage['cty'];
                                              InterviewFormStorage.logoUrl =
                                                  companyPage['logo'];

                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          CreateInterviewEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Create New"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //for job offer request card
                          Card(
                            elevation: 6,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ScreenUtil().setHeight(100.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('jobOfferRequest')
                                            .doc(CompanyStorage.companyId)
                                            .collection('companyJobOfferPages')
                                            .doc(CompanyStorage.pageId)
                                            .collection(
                                                'companyJobOfferDetails')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final jobOfferRequests =
                                                snapshot.data!.docs;
                                            if (jobOfferRequests.isEmpty) {
                                              return Text(
                                                  '${jobOfferRequests.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            } else {
                                              return Text(
                                                  '${jobOfferRequests.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            }
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            print('waiting');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            print('has error');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            print('nothing');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 5.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/inperson.svg",
                                            height:
                                                ScreenUtil().setHeight(30.0),
                                            width: ScreenUtil().setWidth(30.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('JOB OFFERS',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kNavBg),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sentJobOfferRequests')
                                                          .doc(
                                                              JobOfferFormStorage
                                                                  .companyId)
                                                          .collection(
                                                              'sentJobOfferCompanyPage')
                                                          .doc(JobOfferFormStorage
                                                              .mainCompanyId)
                                                          .collection(
                                                              'sentJobOfferDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final sentJobOfferRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (sentJobOfferRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Sent[${sentJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Sent[${sentJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.green,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'AcceptedJobOfferRequests')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'AcceptedJobOfferCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'AcceptedJobOfferDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final acceptedJobOfferRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (acceptedJobOfferRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Accepted[${acceptedJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Accepted[${acceptedJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: kShade,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'DeclinedJobOfferRequests')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'DeclinedJobOfferRequestsCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'DeclinedJobOfferRequestsDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final declinedJobOfferRequests =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (declinedJobOfferRequests
                                                              .isEmpty) {
                                                            return Text(
                                                                'Declined[${declinedJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Declined[${declinedJobOfferRequests.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          AdminJobOfferEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Review"),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              JobOfferFormStorage.companyName =
                                                  companyPage['name'];
                                              JobOfferFormStorage.jobLocation =
                                                  companyPage['cty'];
                                              JobOfferFormStorage.logoUrl =
                                                  companyPage['logo'];
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          CreateJobOfferEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Create New"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

//for appointment card
                          Card(
                            elevation: 6,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: ScreenUtil().setHeight(100.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('appointmentLetter')
                                            .doc(CompanyStorage.companyId)
                                            .collection(
                                                'companyAppointmentLetterPages')
                                            .doc(CompanyStorage.pageId)
                                            .collection(
                                                'companyAppointmentLetterDetails')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final appointmentLetters =
                                                snapshot.data!.docs;
                                            if (appointmentLetters.isEmpty) {
                                              return Text(
                                                  '${appointmentLetters.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            } else {
                                              return Text(
                                                  '${appointmentLetters.length}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(38.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ));
                                            }
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            print('waiting');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            print('has error');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            print('nothing');
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 5.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "images/jobs/inperson.svg",
                                            height:
                                                ScreenUtil().setHeight(30.0),
                                            width: ScreenUtil().setWidth(30.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('APPOINTMENT LETTER',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kNavBg),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.lightBlue,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sentAppointmentLetters')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'sentAppointmentLettersCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'sentAppointmentLettersDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final sentAppointmentLetters =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (sentAppointmentLetters
                                                              .isEmpty) {
                                                            return Text(
                                                                'Sent[${sentAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Sent[${sentAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.green,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'AcceptedAppointmentLetter')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'AcceptedAppointmentLetterCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'AcceptedAppointmentLetterDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final acceptedAppointmentLetters =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (acceptedAppointmentLetters
                                                              .isEmpty) {
                                                            return Text(
                                                                'Accepted[${acceptedAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Accepted[${acceptedAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.remove_circle,
                                                  color: kShade,
                                                  size: 14.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'DeclinedAppointmentLetters')
                                                          .doc(CompanyStorage
                                                              .companyId)
                                                          .collection(
                                                              'DeclinedAppointmentLettersCompanyPage')
                                                          .doc(CompanyStorage
                                                              .pageId)
                                                          .collection(
                                                              'DeclinedAppointmentLettersDetails')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final declinedAppointmentLetters =
                                                              snapshot
                                                                  .data!.docs;
                                                          if (declinedAppointmentLetters
                                                              .isEmpty) {
                                                            return Text(
                                                                'Declined[${declinedAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          } else {
                                                            return Text(
                                                                'Declined[${declinedAppointmentLetters.length}]',
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ));
                                                          }
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          print('waiting');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print('has error');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          print('nothing');
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          AdminAppointmentEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Review"),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              AppointmentStorage.logoUrl =
                                                  companyPage['logo'];
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          CreateAppointmentEntry()));
                                            },
                                            color: Colors.black,
                                            textColor: Colors.white,
                                            child: Text("Create New"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
