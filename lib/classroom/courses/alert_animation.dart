import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class AlertAnimation extends StatelessWidget {
  const AlertAnimation({
    Key? key,
    required this.animation,
    required this.sectionCount,
  }) : super(key: key);

  final Animation<Offset> animation;
  final int sectionCount;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'section',
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kFbColor,
                fontSize: 22.sp,
              ),
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' $sectionCount ',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor2,
                    fontSize: 22.sp,
                  ),
                ),
              ),
              TextSpan(
                text: ' complete?',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kFbColor,
                    fontSize: 22.sp,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
