import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/Storage.dart';
import 'package:sparks/alumni/alumni_registration2.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_interface.dart';
import 'package:sparks/school_reg/screens/second_screen.dart';
import 'dart:ui';
import 'strings.dart';

class Registration extends StatefulWidget {
  static String id = "School-Personal";

  @override
  State<StatefulWidget> createState() {
    return _Registration();
  }
}

class _Registration extends State<Registration> {
  List<String> userChip = [];

  void addChoice(String choice) {
    if (userChip.contains(choice)) {
      userChip.retainWhere((element) => element.contains(choice));
    } else {
      userChip.clear();
      userChip.add(choice);
    }
  }

  String textDisplay = "Select your Level";

  void changeCampusState() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kADarkRed,
        body: Container(
          margin: EdgeInsets.all(
            5.0,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.030,
                    ),
                    Container(
                      height: 10.0,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              kAppBarConnectWithYour,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              kAppBarSchoolMatesAlumni,
                              style: TextStyle(
                                color: kADeepOrange,
                                fontSize: 16.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              kAppBarEnjoyInteractionsMentorShipTutorshipWithYour,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              kAppBarSchoolMatesAlumniGetAmazingSalesDiscounts,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              kAppBarInternshipScholarshipsJobOffersFromYourAlumni,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          child:
                              SvgPicture.asset("images/alumni/school_icon.svg"),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  kAppBarSelectYourCurrentSkill_EducationalStatus,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              kAppBarCanBeUpdatedLaterInYourProfile,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                            Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: <Widget>[
                                ChoiceChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.blue.shade900,
                                      child: Text('CU')),
                                  selectedColor: kALightRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical()),
                                  label: Text(
                                    kAppBarInCampusUniversity,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Rajdhani',
                                      fontWeight: FontWeight.bold,
                                      color: kABlack,
                                    ),
                                  ),
                                  selected: userChip
                                          .contains(kAppBarInCampusUniversity)
                                      ? true
                                      : false,
                                  onSelected: (value) {
                                    setState(() {
                                      textDisplay = "In campus/university";
                                      Storage.isCampusUniversity = true;
                                      Storage.isInPostGraduateCollege = false;
                                      Storage.isUniversityGraduate = false;
                                      Storage.isPostGraduate = false;
                                      addChoice(kAppBarInCampusUniversity);
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.blue.shade900,
                                      child: Text('GC')),
                                  selectedColor: kALightRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical()),
                                  label: Text(
                                    kAppBarInPostGraduateCollege,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Rajdhani',
                                      fontWeight: FontWeight.bold,
                                      color: kABlack,
                                    ),
                                  ),
                                  selected: userChip.contains(
                                          kAppBarInPostGraduateCollege)
                                      ? true
                                      : false,
                                  onSelected: (value) {
                                    setState(() {
                                      textDisplay = "Post graduate college";
                                      textDisplay = "In campus/university";
                                      Storage.isCampusUniversity = false;
                                      Storage.isInPostGraduateCollege = true;
                                      Storage.isUniversityGraduate = false;
                                      Storage.isPostGraduate = false;
                                      addChoice(kAppBarInPostGraduateCollege);
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.blue.shade900,
                                      child: Text('UG')),
                                  selectedColor: kALightRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical()),
                                  label: Column(
                                    children: <Widget>[
                                      Text(
                                        kAppBarUniversityGraduate,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Rajdhani',
                                          fontWeight: FontWeight.bold,
                                          color: kABlack,
                                        ),
                                      ),
                                      Text(
                                        kAppBarNotInPostGraduateCollegeYet,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Rajdhani',
                                          fontWeight: FontWeight.bold,
                                          color: kABlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected: userChip.contains(
                                          kAppBarUniversityGraduateNotInPostGraduateCollegeYet)
                                      ? true
                                      : false,
                                  onSelected: (value) {
                                    setState(() {
                                      textDisplay = "university graduate";
                                      textDisplay = "In campus/university";
                                      Storage.isCampusUniversity = false;
                                      Storage.isInPostGraduateCollege = false;
                                      Storage.isUniversityGraduate = true;
                                      Storage.isPostGraduate = false;
                                      addChoice(
                                          kAppBarUniversityGraduateNotInPostGraduateCollegeYet);
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.blue.shade900,
                                      child: Text('PG')),
                                  selectedColor: kALightRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical()),
                                  label: Text(
                                    kAppBarPostGraduate,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Rajdhani',
                                      fontWeight: FontWeight.bold,
                                      color: kABlack,
                                    ),
                                  ),
                                  selected:
                                      userChip.contains(kAppBarPostGraduate)
                                          ? true
                                          : false,
                                  onSelected: (value) {
                                    setState(() {
                                      textDisplay = "post graduate";
                                      textDisplay = "In campus/university";
                                      Storage.isCampusUniversity = false;
                                      Storage.isInPostGraduateCollege = false;
                                      Storage.isUniversityGraduate = false;
                                      Storage.isPostGraduate = true;
                                      addChoice(kAppBarPostGraduate);
                                    });
                                  },
                                ),
                              ],
                            ),
                            RaisedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    builder: (context) {
                                      return SchoolAdminInterface();
                                    });
                              },
                              color: kSsprogresscompleted,
                              child: Text(
                                'Classroom'.toUpperCase(),
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
                              onPressed: () {
                                //SchoolSecondScreen
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: SchoolSecondScreen()));
                              },
                              color: kALightRed,
                              child: Text(
                                'Add School'.toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (userChip.length == 0) {
                                      Fluttertoast.showToast(
                                          msg: "select a field",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white);
                                    } else {
                                      GeneralFunction.selectedValue =
                                          userChip[0];
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Registration2(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 75.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kADeepOrange,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    width: MediaQuery.of(context).size.width *
                                        0.296,
                                    child: Center(
                                        child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color: kAWhite,
                                        fontFamily: "Rajdhani",
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
