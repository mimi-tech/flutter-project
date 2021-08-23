import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class SubTitle extends StatefulWidget {
  @override
  _SubTitleState createState() => _SubTitleState();
  SubTitle({
    this.title,
  });
  final String? title;
}

class _SubTitleState extends State<SubTitle> {
  var count = ucontacts.lcontacts.length;

  @override
  Widget build(BuildContext context) {
    return Text(widget.title!,
        style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: kBlackcolor,
        )));
  }
}
