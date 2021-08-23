import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class PostViewers extends StatefulWidget {
  @override
  _PostViewersState createState() => _PostViewersState();
}

class _PostViewersState extends State<PostViewers> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('This post is for who'.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize:20.sp,
                fontWeight: FontWeight.bold,
                color: kExpertColor,
              ),

            ),
          ),

          RadioListTile(
            activeColor: kFbColor,
            groupValue: SchClassConstant.radioItem,
            title: Text(kPublic1,
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.w500,
                color: kBlackcolor,
              ),

            ),
            value: kPublic1,
            onChanged: (dynamic val) {
              setState(() {
                SchClassConstant.radioItem = val;
              });
              Navigator.pop(context);
            },
          ),

          RadioListTile(
            activeColor: kFbColor,
            groupValue: SchClassConstant.radioItem,
            title: Text(kPublic2,
      style: GoogleFonts.rajdhani(
      fontSize:kFontsize.sp,
      fontWeight: FontWeight.w500,
      color: kBlackcolor,
      ),

      ),
            value: kPublic2,
            onChanged: (dynamic val) {
              setState(() {
                SchClassConstant.radioItem = val;
              });
              Navigator.pop(context);

            },
          ),
          RadioListTile(
            activeColor: kFbColor,
            groupValue: SchClassConstant.radioItem,
            title: Text(kPublic3,
      style: GoogleFonts.rajdhani(
      fontSize:kFontsize.sp,
      fontWeight: FontWeight.w500,
      color: kBlackcolor,
      ),

      ),
            value: kPublic3,
            onChanged: (dynamic val) {
              setState(() {
                SchClassConstant.radioItem = val;
              });
              Navigator.pop(context);

            },
          ),
        ],
      ),
    );
  }
}
