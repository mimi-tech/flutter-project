import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/edit/reference.dart';
import 'package:timeago/timeago.dart' as timeago;

class Referee extends StatefulWidget {
  @override
  _RefereeState createState() => _RefereeState();
}

class _RefereeState extends State<Referee> {
  var starCount = 5;

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
          EditProfessionalStorage.referee = resumeDetails["referee"];

          //Todo: get  datetime from database
          DateTime date = DateTime.parse(resumeDetails["date"]);

          String displayDay = timeago.format(date);

          return SafeArea(
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(3.5, 15.0, 0.0, 0.0),
                      height: screenData.height * 0.78,
                      width: screenData.width * 0.98,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
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
                            height: screenData.height * 0.70,
                            width: screenData.width * 0.97,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0.0, 25.0, 0.0, 50.0),
                                    child: Text(
                                      'REFERRAL',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(25.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  for (var i = 0;
                                      i < resumeDetails["referee"].length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 20.0),
                                        child: Column(
                                          children: <Widget>[
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: ScreenUtil()
                                                    .setWidth(380.0),
                                                minHeight: ScreenUtil()
                                                    .setHeight(380.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.white,
                                                ),
                                                width: ScreenUtil()
                                                    .setWidth(380.0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0.0,
                                                                25.0,
                                                                0.0,
                                                                0.0),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          radius: 52,
                                                          child: ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: resumeDetails[
                                                                      "referee"]
                                                                  [i]['image'],
                                                              placeholder: (context,
                                                                      url) =>
                                                                  CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                              fit: BoxFit.cover,
                                                              height: ScreenUtil()
                                                                  .setHeight(
                                                                      500.0),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        ReusableFunctions
                                                            .capitalizeWords(
                                                                resumeDetails[
                                                                        "referee"]
                                                                    [
                                                                    i]['name'])!,
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          18.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      //margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                                                      child: Text(
                                                        ReusableFunctions
                                                            .capitalizeWords(
                                                                resumeDetails[
                                                                        "referee"][i]
                                                                    [
                                                                    'companyName'])!,
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          16.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
                                                    //   child: Text(
                                                    //     ReusableFunctions.capitalizeWords(displayDay),
                                                    //     style:GoogleFonts.rajdhani(
                                                    //       textStyle:TextStyle(
                                                    //           fontSize:12.sp,
                                                    //           fontWeight: FontWeight.bold,
                                                    //           color: Colors.black),),
                                                    //
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10.0,
                                                              0.0,
                                                              10.0,
                                                              5.0),
                                                      child: ReadMoreText(
                                                        resumeDetails["referee"]
                                                                [i]
                                                            ['recommendation'],
                                                        trimLines: 6,
                                                        colorClickableText:
                                                            kMore,
                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText:
                                                            ' ...Show more',
                                                        trimExpandedText:
                                                            ' ...Show less',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              20.0,
                                                              15.0,
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            "- ${ReusableFunctions.capitalizeWords(resumeDetails["referee"][i]['occupation'])}",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              18.0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                          Text(
                                                            "-${resumeDetails["referee"][i]['phoneNumber']}",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              14.0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
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
                                    ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 5.0, 0.0, 20.0),
                                          child: RaisedButton(
                                            onPressed: () {
                                              if (ProfessionalStorage
                                                      .isLoggedInUser(
                                                          UserStorage
                                                              .loggedInUser.uid,
                                                          ProfessionalStorage
                                                              .id) ==
                                                  true) {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child: EditReferral()));
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
                                              ProfessionalStorage
                                                      .isLoggedInUser(
                                                          UserStorage
                                                              .loggedInUser.uid,
                                                          ProfessionalStorage
                                                              .id)
                                                  ? 'EDIT'
                                                  : "Employ Me",
                                            ),
                                            textColor: Colors.white,
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
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
