import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class SchoolHeader extends StatelessWidget {
  SchoolHeader({required this.title});

  final String title;

  Widget space() {
    return SizedBox(height: 10.h);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhitecolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      height: 65.h,
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Center(
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      color: kFbColor,
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: kBlackcolor,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    )),
              )),
          //space(),
          Divider(
            thickness: 3.0,
            color: kExpertColor,
          ),
        ],
      ),
    );
  }
}

class QuestionHeader extends StatelessWidget {
  QuestionHeader({required this.title, required this.askQues});

  final String title;
  final Function askQues;

  Widget space() {
    return SizedBox(height: 10.h);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhitecolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      height: 65.h,
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          color: kFbColor,
                          fontSize: kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: kBlackcolor,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        )),
                  ),
                  SchClassConstant.isTeacher
                      ? Text('')
                      : RaisedButton(
                    onPressed: askQues as void Function()?,
                    color: kExpertColor,
                    child: Text(
                      'Ask here',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kWhitecolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          //space(),
          Divider(
            thickness: 3.0,
            color: kExpertColor,
          ),
        ],
      ),
    );
  }
}
