import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class CheckNetwork extends StatefulWidget {
  @override
  _CheckNetworkState createState() => _CheckNetworkState();
}

class _CheckNetworkState extends State<CheckNetwork> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.network_check,
          size: 200,
          color: klistnmber,
        ),
        Text(
          'Sorry You have No Internet connection',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        )
      ],
    );
  }
}
