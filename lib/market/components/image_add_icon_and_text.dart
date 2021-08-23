import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageAddIconAndText extends StatelessWidget {
  final String buttonText;

  ImageAddIconAndText({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.add,
          color: Colors.grey,
          size: 64.0,
        ),
        Text(
          buttonText,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
