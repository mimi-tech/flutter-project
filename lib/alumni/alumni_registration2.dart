import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/alumni/Storage.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'dart:ui';
import 'strings.dart';

class Registration2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Registration2();
  }
}

class _Registration2 extends State<Registration2> {
  final TextEditingController inputSelect = TextEditingController();

  List<String> picked = [
    "Higher-certificate",
    "National-diploma",
    "Bachelor's-degree",
    "Honour's-degree",
    "Master's-degree",
    "Doctoral-degree",
  ];

  List<String> input = [
    "100-level",
    "200-level",
    "300-level",
    "400-level",
    "500-level",
    "600-level",
    "700-level",
    "800-level",
  ];

  List<String> pickedInput() {
    List<String> result = [];

    if (GeneralFunction.selectedValue == kAppBarInCampusUniversity) {
      result = input;
    } else if (GeneralFunction.selectedValue == kAppBarInPostGraduateCollege) {
      result = input;
    } else if (GeneralFunction.selectedValue ==
        kAppBarUniversityGraduateNotInPostGraduateCollegeYet) {
      result = picked;
    } else if (GeneralFunction.selectedValue == kAppBarPostGraduate) {
      result = picked;
    }
    return result;
  }

  late String showHint;
  final TextEditingController selectedChoiceCard = TextEditingController();

  void updateGradeToProfile() {
    if (Storage.isCampusUniversity == true) {
      DocumentReference personalInfo = FirebaseFirestore.instance
          .collection('users')
          .doc(SchoolUserStorage.loggedInUser.uid)
          .collection('Personal')
          .doc("personalInfo");
      personalInfo.set({
        "grade"
            "vt": true
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });
      CupertinoAlertDialog(
        title: Text(
          "Welcome to sparks",
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SvgPicture.asset("Images/Alumni/successful.svg"),
      );
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: School()));
    } else if (Storage.isInPostGraduateCollege == true &&
        inputSelect.text != "") {
      DocumentReference personalInfo = FirebaseFirestore.instance
          .collection('users')
          .doc(SchoolUserStorage.loggedInUser.uid)
          .collection('Personal')
          .doc("personalInfo");
      personalInfo.set({
        "level": inputSelect.text,
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });
      CupertinoAlertDialog(
        title: Text(
          "Welcome to sparks",
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SvgPicture.asset("Images/Alumni/successful.svg"),
      );
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: School()));
    } else if (Storage.isPostGraduate == true && inputSelect.text != "") {
      DocumentReference personalInfo = FirebaseFirestore.instance
          .collection('users')
          .doc(SchoolUserStorage.loggedInUser.uid)
          .collection('Personal')
          .doc("personalInfo");
      personalInfo.set({
        "title": inputSelect.text,
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });
      CupertinoAlertDialog(
        title: Text(
          "Welcome to sparks",
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SvgPicture.asset("Images/Alumni/successful.svg"),
      );
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: School()));
    } else if (Storage.isUniversityGraduate == true) {
      DocumentReference personalInfo = FirebaseFirestore.instance
          .collection('users')
          .doc(SchoolUserStorage.loggedInUser.uid)
          .collection('Personal')
          .doc("personalInfo");
      personalInfo.set({
        "title"
            "vt": true
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });
      CupertinoAlertDialog(
        title: Text(
          "Welcome to sparks",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SvgPicture.asset("Images/Alumni/successful.svg"),
      );
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: School()));
    } else {
      ReusableFunctions.showToastMessage2(
          "Please the above field is required", Colors.white, Colors.red);
    }
  }

  List<String> userChip = [];

  void addChoice(String choice) {
    if (userChip.contains(choice)) {
      userChip.retainWhere((element) => element.contains(choice));
    } else {
      userChip.clear();
      userChip.add(choice);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchoolUserStorage.getCurrentUser();
    if (Storage.isCampusUniversity == true) {
      showHint = "Select Your Level";
    } else if (Storage.isInPostGraduateCollege == true) {
      showHint = "Select Your Level";
    } else if (Storage.isPostGraduate == true) {
      showHint = "Select Title Obtained";
    } else if (Storage.isUniversityGraduate == true) {
      showHint = "Select Title Obtained";
    }

    print(Storage.isCampusUniversity);
    print(Storage.isInPostGraduateCollege);
    print(Storage.isUniversityGraduate);
    print(Storage.isPostGraduate);
  }

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
                      height: MediaQuery.of(context).size.height * 0.052,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    showHint,
                                    style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  // DropDownField(
                                  //   controller: inputSelect,
                                  //   hintText: "Type something",
                                  //   enabled: true,
                                  //   itemsVisibleInDropdown: 5,
                                  //   items: pickedInput(),
                                  //   onValueChanged: (value) {
                                  //     setState(() {
                                  //       selectCategory = value;
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.060,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    updateGradeToProfile();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 50.0,
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
                                      kAppBarContinue,
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

String selectCategory = "";
