import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';










class ContactPE extends StatelessWidget {
  const ContactPE({
    this.title,
    this.content,
  });
  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title!,
            style:GoogleFonts.rajdhani(
              textStyle:TextStyle(
                  fontSize:ScreenUtil().setSp(18.0),
                  fontWeight: FontWeight.bold,
                  color: kActiveNavColor),),

          ),
          Text(
            content!,
            style:GoogleFonts.rajdhani(
              textStyle:TextStyle(
                  fontSize:ScreenUtil().setSp(16.0),
                  fontWeight: FontWeight.bold,
                  color: kActiveNavColor),),

          ),
        ],
      ),
    );
  }
}
