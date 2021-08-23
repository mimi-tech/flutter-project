import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/aboutComponent.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/edit/about.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;

  @override
  void initState() {
    super.initState();
    ProfessionalStorage.resume = FirebaseFirestore.instance
        .collection('professionals')
        .doc(ProfessionalStorage.id)
        .snapshots();
  }

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

          //TODO: pass data to the edit profile screen
          EditProfessionalStorage.status = resumeDetails['status'];
          EditProfessionalStorage.jobCategory = resumeDetails['ajc'];
          EditProfessionalStorage.jobType = resumeDetails['ajt'];
          EditProfessionalStorage.award = resumeDetails['awDs'];
          EditProfessionalStorage.phoneNumber = resumeDetails['phone'];
          EditProfessionalStorage.location = resumeDetails['location'];
          EditProfessionalStorage.professionalTitle = resumeDetails['pTitle'];
          EditProfessionalStorage.salaryRangeMax = resumeDetails['srx'];
          EditProfessionalStorage.salaryRangeMin = resumeDetails['srn'];
          EditProfessionalStorage.id = resumeDetails['userId'];
          EditProfessionalStorage.logoUrl = resumeDetails['imageUrl'];
          EditProfessionalStorage.profileName = resumeDetails['name'];

          return Container(
            child: ListView(
              children: [
                SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(640),
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          height: ScreenUtil().setHeight(450),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: resumeDetails["imageUrl"],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 250,
                        left: 0.0,
                        right: 0.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: ScreenUtil().setHeight(380.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                  height: ScreenUtil().setHeight(70),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      AboutMiddleComponentOne(
                                        hourNumber:
                                            "${resumeDetails['avgRt'].toString()}",
                                        hourText: 'Stars Rating',
                                      ),
                                      AboutMiddleComponentOne(
                                        hourNumber:
                                            resumeDetails['pjd'].toString(),
                                        hourText: 'Projects done',
                                      ),
                                      AboutMiddleComponentOne(
                                        hourNumber: resumeDetails['experience']
                                            .length
                                            .toString(),
                                        hourText: 'Experience',
                                      ),
                                      AboutMiddleComponentOne(
                                        hourNumber:
                                            resumeDetails['awards'].toString(),
                                        hourText: 'Awards',
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(240),
                                  width: double.infinity,
                                  color: kAboutMiddleColor2,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 10.0),
                                        height: ScreenUtil().setHeight(110),
                                        width: double.infinity,
                                        color: kAboutMiddleColor2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Expanded(
                                                child: Text(
                                                  resumeDetails['name'],
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            kAboutMiddleTextColor4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                resumeDetails['pTitle'],
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(12.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kActiveNavColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                "\$${resumeDetails['srn']} - \$${resumeDetails['srx']}",
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kActiveNavColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add_location,
                                                    color:
                                                        kAboutMiddleTextColor3,
                                                  ),

                                                  ///ProfileStorage.profileId
                                                  Text(
                                                    ReusableFunctions
                                                        .displayProfessionalName(
                                                            resumeDetails[
                                                                'location'])!,
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(16.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              kAboutMiddleTextColor3),
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
                                            0.0, 5.0, 0.0, 0.0),
                                        height: ScreenUtil().setHeight(100),
                                        width: double.infinity,
                                        color: kBackgroundColor,
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  4.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Text(
                                                        '${ReusableFunctions.capitalizeWords(resumeDetails["status"])} For',
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          16),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  kAboutMiddleTextColor1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Text(
                                                        "Job Types:",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .query_builder,
                                                                  color:
                                                                      kAboutMiddleTextColor3,
                                                                ),
                                                                Text(
                                                                  resumeDetails[
                                                                      "ajc"],
                                                                  style: GoogleFonts
                                                                      .rajdhani(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                12),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    8.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .query_builder,
                                                                  color:
                                                                      kAboutMiddleTextColor3,
                                                                ),
                                                                Text(
                                                                  resumeDetails[
                                                                      "ajt"],
                                                                  style: GoogleFonts
                                                                      .rajdhani(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                12),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: screenData.width * 0.56,
                                                decoration: BoxDecoration(
                                                  //image: DecorationImage( image: AssetImage('images/jobs/at.svg'), fit: BoxFit.fill),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "images/jobs/ratebg.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0.0,
                                                              0.0,
                                                              10.0,
                                                              0.0),
                                                      child: Text(
                                                        'STATUS:  ${ReusableFunctions.capitalizeWords(resumeDetails["status"])}',
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          18),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0.0,
                                                              0.0,
                                                              10.0,
                                                              0.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          RatingBar.builder(
                                                            initialRating:
                                                                resumeDetails[
                                                                        'avgRt']
                                                                    .toDouble(),
                                                            minRating: 1,
                                                            unratedColor:
                                                                Colors.white,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            ignoreGestures:
                                                                true,
                                                            itemSize: 25,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (double) {},
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color: kNavBg,
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10.0,
                                                              0.0,
                                                              10.0,
                                                              0.0),
                                                      height: ScreenUtil()
                                                          .setHeight(30.0),
                                                      width: ScreenUtil()
                                                          .setWidth(120.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.white,
                                                            size: ScreenUtil()
                                                                .setSp(8),
                                                          ),
                                                          Text(
                                                            'My Work Ratings',
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              14),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
