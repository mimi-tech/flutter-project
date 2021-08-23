import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/jobs/colors/colors.dart';

//The component for hours and worked on about us screen
class AboutMiddleComponentOne extends StatelessWidget {
  const AboutMiddleComponentOne({required this.hourNumber, this.hourText});

  final String hourNumber;
  final String? hourText;
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            hourNumber,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: kAboutMiddleTextColor1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Text(
              hourText!,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: kAboutMiddleTextColor3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
