import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class DeleteThumbnail extends StatelessWidget {
  DeleteThumbnail({required this.delete});
  final Function delete;
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: delete as void Function()?,
      child: Text(
        kSRemoveThumbnail,
        style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
          fontSize: kFontsize.sp,
          color: kFbColor,
        )),
      ),
    );
  }
}
