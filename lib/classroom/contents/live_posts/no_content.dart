import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class NoContentCreated extends StatelessWidget {
  const NoContentCreated({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          height: ScreenUtil().setHeight(300),
          width: ScreenUtil().setHeight(350),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              width: 2.0,
              color: klistnmber,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  color: kBlackcolor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
