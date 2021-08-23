import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/live/content_live_post.dart';
import 'package:sparks/classroom/courseAdmin/admin_page.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/course_company/company_analysis.dart';
import 'package:sparks/classroom/courseAdmin/course_company/staff_analysis.dart';
import 'package:sparks/classroom/courseAdmin/course_updated.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseSilverAppBar extends StatefulWidget implements PreferredSizeWidget {
  CourseSilverAppBar({
    required this.matches,
    required this.friends,
    required this.classroom,
    required this.content,
  });
  final Color matches;
  final Color friends;
  final Color classroom;
  final Color content;

  @override
  _CourseSilverAppBarState createState() => _CourseSilverAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _CourseSilverAppBarState extends State<CourseSilverAppBar> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewAdded();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      )),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AdminPageOne()));
              },
              child: Badge(
                badgeContent:
                    Text(CourseAdminConstants.newCount.length.toString()),
                child: Text(
                  'New',
                  style: TextStyle(
                    fontSize: kAppbar.sp,
                    color: widget.matches,
                    fontFamily: 'Rajdhani',
                    shadows: [
                      Shadow(
                        blurRadius: kSblur,
                        color: kBlackcolor,
                        offset: Offset(kshadowoffset, kshadowoffset),
                      ),
                    ],
                  ),
                ),
                toAnimate: true,
                badgeColor: kFbColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
              )
              /**/
              ),

          //TODO:friends tab
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdatedCourses()));
              },
              child: Badge(
                badgeContent:
                    Text(CourseAdminConstants.updatedCount.length.toString()),
                child: Text(
                  'Updated',
                  style: TextStyle(
                    fontSize: kAppbar.sp,
                    color: widget.friends,
                    fontFamily: 'Rajdhani',
                    shadows: [
                      Shadow(
                        blurRadius: kSblur,
                        color: kBlackcolor,
                        offset: Offset(kshadowoffset, kshadowoffset),
                      ),
                    ],
                  ),
                ),
                toAnimate: true,
                badgeColor: kFbColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
              )),

          GlobalVariables.loggedInUserObject.id ==
                  CourseAdminConstants.adminData[0]['uid']
              ? GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CompanyAnalysis()));
                  },
                  child: Text(
                    'Analysis',
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.classroom,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: kSblur,
                          color: kBlackcolor,
                          offset: Offset(kshadowoffset, kshadowoffset),
                        ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StaffAnalysis()));
                  },
                  child: Text(
                    'Analysis',
                    style: GoogleFonts.rajdhani(
                      fontSize: kAppbar.sp,
                      color: widget.classroom,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: kSblur,
                          color: kBlackcolor,
                          offset: Offset(kshadowoffset, kshadowoffset),
                        ),
                      ],
                    ),
                  ),
                ),

          //TODO:New matches tab

          GestureDetector(
            onTap: () {
              var date = new DateTime.now().toString();

              var dateParse = DateTime.parse(date);

              var formattedDate =
                  "${dateParse.day}/${dateParse.month}/${dateParse.year}";

              DateTime logOut = DateTime.now();
              var time = DateFormat("hh:mm:a").format(logOut);

              /*getting the different in login and logout time*/

              var logOutTime = DateFormat("hh:mm:a").format(logOut);
              var logInTime =
                  DateFormat("hh:mm").format(CourseAdminConstants.loginTime);

              var format = DateFormat("hh:mm");
              var one = format.parse(logInTime);
              var two = format.parse(logOutTime);

              var hours = two.difference(one);
              int hoursCount = hours.inHours;
              int minutesCount = hours.inMinutes;

              /*  */ /*getting the month name*/ /*
              List months = ['January','Febuary','March','April','May','June','July','August','September','Octobar','Novermber','December'];
              var now = new DateTime.now();
              var currentMon = now.month;
*/

              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                          children: <Widget>[
                            Center(
                              child: Text(
                                CourseAdminConstants.adminData[0]['fn'],
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kExpertColor,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                            ),
                            space(),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Date',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kMaincolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formattedDate.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: kBlackcolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Time',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kMaincolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      time.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: kBlackcolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            space(),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: Text(
                                kSignOutText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBlackcolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ),
                              ),
                            ),
                            space(),
                            progress == true
                                ? Center(child: ProgressIndicatorState())
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                        color: klistnmber,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kWhitecolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      RaisedButton(
                                        color: kFbColor,
                                        onPressed: () async {
                                          User currentUser =
                                              FirebaseAuth.instance.currentUser!;

                                          /*update the database*/
                                          setState(() {
                                            progress = true;
                                          });
                                          try {
                                            /*check if document exist*/
                                            final snapShot = await FirebaseFirestore
                                                .instance
                                                .collection(
                                                    "companyVerifiedCourses")
                                                .doc(CourseAdminConstants
                                                    .adminData[0]['id'])
                                                .collection(
                                                    'companyVerifiedCoursesCount')
                                                .doc(currentUser.uid)
                                                .get();

                                            if (snapShot != null ||
                                                snapShot.exists) {
                                              // Document with id == docId doesn't exist.
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      "companyVerifiedCourses")
                                                  .doc(CourseAdminConstants
                                                      .adminData[0]['id'])
                                                  .collection(
                                                      'companyVerifiedCoursesCount')
                                                  .doc(currentUser.uid)
                                                  .set(
                                                      {
                                                    'lg': false,
                                                    'time':
                                                        "${Jiffy().hour}:${Jiffy().minute}",
                                                    'lo': logOut,
                                                    'hr': hoursCount,
                                                    'min': minutesCount,
                                                  },
                                                      SetOptions(
                                                          merge:
                                                              true)).whenComplete(
                                                      () {
                                                setState(() {
                                                  progress = false;
                                                });
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .topToBottom,
                                                        child: LiveContent()));
                                              }).catchError((onError) {
                                                setState(() {
                                                  progress = false;
                                                });
                                              });
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .topToBottom,
                                                      child: LiveContent()));
                                            }
                                          } catch (e) {
                                            setState(() {
                                              progress = false;
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Yes',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kWhitecolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                          ]));
            },
            child: Text(
              'SignOut',
              style: TextStyle(
                fontSize: kAppbar.sp,
                color: widget.content,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rajdhani',
                shadows: [
                  Shadow(
                    blurRadius: kSblur,
                    color: kBlackcolor,
                    offset: Offset(kshadowoffset, kshadowoffset),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: kSappbarbacground,
      floating: true,
      snap: true,
      pinned: false,
    );
  }

  void getNewAdded() {}
}
/* DocumentReference documentReference = FirebaseFirestore.instance
                                    .collection("CourseAdminAnalysis")
                                    .doc(CourseAdminConstants.adminData[0]['id'],)
                                    .collection('workingHour').doc(currentUser.uid);
                                documentReference.setData({
                                   'uid':currentUser.uid,

                                  'lo':logOut,
                                  'yr':DateTime.now().year,
                                  'mth':DateTime.now().month,
                                  'month':months[currentMon -1],
                                  'hr':hoursCount,
                                  'min':minutesCount,
                                  'day':DateTime.now().day,
                                  'today':formattedDate,
                                  'wk':DateTime.now().weekday,
                                  'comId':CourseAdminConstants.adminData[0]['id'],
                                  'name':CourseAdminConstants.adminData[0]['name'],
                                  'fn': CourseAdminConstants.adminData[0]['fn'],
                                  'email':CourseAdminConstants.adminData[0]['email'],
                                  'pix':CourseAdminConstants.adminData[0]['pimg'],
                                  'lg': false,
                                'lot':two,*/
