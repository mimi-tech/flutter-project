import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class DialogBtn extends StatelessWidget {
  const DialogBtn({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: kPreviewcolor,
      child: Text(kDone,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: kWhitecolor,
              fontSize: kFontsize.sp,
            ),
          )),
    );
  }
}
