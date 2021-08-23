import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/jobs/colors/colors.dart';

//for the skill experience box
class SkillBox extends StatelessWidget {
  const SkillBox({required this.skillIcon, this.skillText});
  final String skillIcon;
  final String? skillText;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: ScreenUtil().setWidth(105),
        minHeight: ScreenUtil().setHeight(100.0),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 30.0),
        height: ScreenUtil().setHeight(100.0),
        decoration: BoxDecoration(
          color: kServiceBg2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: ScreenUtil().setHeight(30.0),
                  width: ScreenUtil().setWidth(30.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(skillIcon),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    skillText!,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: kAboutMiddleTextColor3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//for education and experience main content
class ExContent extends StatelessWidget {
  const ExContent({
    required this.dString,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.color,
  });
  final String dString;
  final String? text1;
  final String? text2;
  final String? text3;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setSp(160),
                        minHeight: ScreenUtil().setSp(2)),
                    child: Text(
                      text1!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setSp(160),
                        minHeight: ScreenUtil().setSp(2)),
                    child: Text(
                      text2!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setSp(160),
                        minHeight: ScreenUtil().setSp(2)),
                    child: Text(
                      text3!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: color),
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
  }
}

//for education and experience side shape

class EComponent extends StatelessWidget {
  const EComponent({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
            child: Text(
              title,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(20.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoShot extends StatelessWidget {
  const PhotoShot({
    required this.hobby,
  });
  final String? hobby;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
      height: ScreenUtil().setHeight(40.0),
      width: ScreenUtil().setWidth(120),
      decoration: BoxDecoration(
        color: kServiceBg2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(
            hobby!,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(20.0),
                  fontWeight: FontWeight.bold,
                  color: kAboutMiddleTextColor3),
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayExperience extends StatelessWidget {
  const DisplayExperience({
    Key? key,
    required this.resumeDetails,
    required this.i,
  }) : super(key: key);

  final Map<String, dynamic> resumeDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['experience'][i]["companyName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(22.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['experience'][i]["jobLocation"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "(${resumeDetails['experience'][i]["start"]} - ${resumeDetails['experience'][i]["end"]})",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: kActiveNavColor),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "${resumeDetails['experience'][i]["jobRole"]}.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(19.0),
                          fontWeight: FontWeight.bold,
                          color: kAboutMiddleTextColor1),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(280),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['experience'][i]["jobDescription"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayExperienceEdit extends StatelessWidget {
  const DisplayExperienceEdit({
    Key? key,
    required this.experienceDetails,
    required this.i,
  }) : super(key: key);

  final List? experienceDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    experienceDetails!.elementAt(i)["companyName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(22.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    experienceDetails!.elementAt(i)["jobLocation"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "(${experienceDetails!.elementAt(i)["start"]} - ${experienceDetails!.elementAt(i)["end"]})",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${experienceDetails!.elementAt(i)["jobRole"]}.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(19.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(200),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    experienceDetails!.elementAt(i)["jobDescription"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayProjects extends StatelessWidget {
  const DisplayProjects({
    Key? key,
    required this.resumeDetails,
    required this.i,
  }) : super(key: key);

  final Map<String, dynamic> resumeDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      resumeDetails['projects'][i]["title"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(16.0),
                            fontWeight: FontWeight.bold,
                            color: kActiveNavColor),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(220),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['projects'][i]["description"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayProjectsEdit extends StatelessWidget {
  const DisplayProjectsEdit({
    Key? key,
    required this.projectDetails,
    required this.i,
  }) : super(key: key);

  final List? projectDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        projectDetails!.elementAt(i)["title"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(16.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(220),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    projectDetails!.elementAt(i)["description"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayEducation extends StatelessWidget {
  const DisplayEducation({
    Key? key,
    required this.resumeDetails,
    required this.i,
  }) : super(key: key);

  final Map<String, dynamic> resumeDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['education'][i]["schoolName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['education'][i]["schoolLocation"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "(${resumeDetails['education'][i]["start"]} - ${resumeDetails['education'][i]["end"]})",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: kActiveNavColor),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "${resumeDetails['education'][i]["certification"]}. - "
                    "${resumeDetails['education'][i]["course"]}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: kAboutMiddleTextColor1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayEducationEdit extends StatelessWidget {
  const DisplayEducationEdit({
    Key? key,
    required this.educationDetails,
    required this.i,
  }) : super(key: key);

  final List? educationDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    educationDetails!.elementAt(i)["schoolName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    educationDetails!.elementAt(i)["schoolLocation"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "(${educationDetails!.elementAt(i)["start"]} - ${educationDetails!.elementAt(i)["end"]})",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    "${educationDetails!.elementAt(i)["certification"]}. - "
                    "${educationDetails!.elementAt(i)["course"]}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayAwards extends StatelessWidget {
  const DisplayAwards({
    Key? key,
    required this.resumeDetails,
    required this.i,
  }) : super(key: key);

  final Map<String, dynamic> resumeDetails;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/jobs/dm.png"),
                    ),
                    color: Colors.black),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  height: ScreenUtil().setHeight(130.0),
                  width: ScreenUtil().setWidth(2),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(180),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      resumeDetails['awDs'][i]["title"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: kActiveNavColor),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(220),
                      minHeight: ScreenUtil().setSp(2)),
                  child: Text(
                    resumeDetails['awDs'][i]["description"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
