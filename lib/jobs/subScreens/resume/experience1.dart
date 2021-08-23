import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/jobs/subScreens/professionals/edit/experience.dart';

class Expert extends StatefulWidget {
  const Expert({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;
  @override
  _ExpertState createState() => _ExpertState();
}

class _ExpertState extends State<Expert> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;
  bool readMore = false;
  String readText = 'showMore';

  void changeDisplayRead() {
    if (readMore) {
      setState(() {
        readText = "showMore";
        readMore = false;
      });
    } else {
      setState(() {
        readText = "showLess";
        readMore = true;
      });
    }
  }

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
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }

          bool checkNumber(num) {
            if (num % 2 == 0) {
              return true;
            } else {
              return false;
            }
          }

          List<Widget> showOdd = [];
          List<Widget> showEven = [];

          Map<String, dynamic> resumeDetails =
              snapshot.data as Map<String, dynamic>;
          EditProfessionalStorage.aboutMe = resumeDetails["abtMe"];
          EditProfessionalStorage.experience = resumeDetails["experience"];
          EditProfessionalStorage.education = resumeDetails["education"];
          EditProfessionalStorage.skills = resumeDetails['skills'];
          EditProfessionalStorage.hobbies = resumeDetails['hobbies'];
          EditProfessionalStorage.id = resumeDetails['userId'];
          EditProfessionalStorage.award = resumeDetails['awDs'];
          EditProfessionalStorage.projects = resumeDetails['projects'];

          for (var i = 0; i < resumeDetails["hobbies"].length; i++) {
            if (checkNumber(i)) {
              showEven.add(PhotoShot(
                hobby: resumeDetails["hobbies"][i],
              ));
            } else {
              showOdd.add(PhotoShot(
                hobby: resumeDetails["hobbies"][i],
              ));
            }
          }

          return SafeArea(
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: screenData.height * 0.81,
                      width: double.infinity,
                      //color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(180.0),
                                  margin:
                                      EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 62,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  resumeDetails["imageUrl"],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                              height:
                                                  ScreenUtil().setHeight(500.0),
                                              width: ScreenUtil().setWidth(500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 25.0, 5.0, 0.0),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                ReusableFunctions
                                                    .displayProfessionalName(
                                                        resumeDetails['name'])!,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(16.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          kAboutMiddleTextColor4),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Expanded(
                                                child: Text(
                                                  ReusableFunctions
                                                      .displayProfessionalName(
                                                          resumeDetails[
                                                              'pTitle'])!,
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
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add_location,
                                                    color:
                                                        kAboutMiddleTextColor3,
                                                  ),
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.arrow_downward,
                                                      color:
                                                          kAboutMiddleTextColor1,
                                                    ),
                                                    Text(
                                                      'Download Resume.pdf',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        16.0),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kAboutMiddleTextColor1),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: EComponent(
                                    title: "About Me.",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      15.0, 0.0, 20.0, 00.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: ReadMoreText(
                                          resumeDetails["abtMe"],
                                          trimLines: 6,
                                          colorClickableText: kMore,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: ' ...Show more',
                                          trimExpandedText: ' ...Show less',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 00.0),
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
                                                child: EditExperience()));
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EComponent(
                                    title: "Skills",
                                  ),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        for (var i = 0;
                                            i < resumeDetails['skills'].length;
                                            i++)
                                          SkillBox(
                                            skillIcon: "images/jobs/ps.png",
                                            skillText: resumeDetails['skills']
                                                [i],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (resumeDetails['experience'].length >= 1)
                                  EComponent(
                                    title: "Work Experience",
                                  ),
                                if (resumeDetails['experience'].length >= 1)
                                  for (var i = 0;
                                      i < resumeDetails['experience'].length;
                                      i++)
                                    DisplayExperience(
                                        resumeDetails: resumeDetails, i: i),
                                if (resumeDetails['projects'].length >= 1)
                                  EComponent(
                                    title: "My Projects",
                                  ),
                                if (resumeDetails['projects'].length >= 1)
                                  for (var i = 0;
                                      i < resumeDetails['projects'].length;
                                      i++)
                                    DisplayProjects(
                                        resumeDetails: resumeDetails, i: i),
                                if (resumeDetails['education'].length >= 1)
                                  EComponent(
                                    title: "Education",
                                  ),
                                if (resumeDetails['education'].length >= 1)
                                  for (var i = 0;
                                      i < resumeDetails['education'].length;
                                      i++)
                                    DisplayEducation(
                                        resumeDetails: resumeDetails, i: i),
                                if (resumeDetails['awDs'].length >= 1)
                                  EComponent(
                                    title: "Awards",
                                  ),
                                if (resumeDetails['awDs'].length >= 1)
                                  for (var i = 0;
                                      i < resumeDetails['awDs'].length;
                                      i++)
                                    DisplayAwards(
                                        resumeDetails: resumeDetails, i: i),
                                EComponent(
                                  title: "What I Can Do",
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            30.0, 0.0, 0.0, 0.0),
                                        height: ScreenUtil().setHeight(30.0),
                                        width: ScreenUtil().setWidth(25),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "images/jobs/dm.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: () {
                                            widget.tabController!.animateTo(2);
                                          },
                                          color: kLight_orange,
                                          child: Text(
                                            'MY SERVICES',
                                          ),
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                EComponent(
                                  title: "Hobbies",
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            30.0, 0.0, 0.0, 0.0),
                                        height: ScreenUtil().setHeight(30.0),
                                        width: ScreenUtil().setWidth(25),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "images/jobs/dm.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: Column(
                                        children: showEven,
                                      )),
                                      Container(
                                          child: Column(
                                        children: showOdd,
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
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
                                                child: EditExperience()));
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
