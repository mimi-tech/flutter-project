import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
class CcAppBar extends StatefulWidget implements PreferredSizeWidget{
  CcAppBar({required this.text1,required this.text2,required this.text3,required this.text4});
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  @override
  _CcAppBarState createState() => _CcAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _CcAppBarState extends State<CcAppBar> {



  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: kBlackcolor,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      backgroundColor: kWhitecolor,
      title: RichText(
        text: TextSpan(
            text:'${widget.text4} ',
            style: GoogleFonts.rajdhani(
              fontSize:16.sp,
              fontWeight: FontWeight.w700,
              color: kBlackcolor,
            ),

            children: <TextSpan>[
              TextSpan(text: '${widget.text1} ',
                style: GoogleFonts.rajdhani(
                  fontSize:16.sp,
                  fontWeight: FontWeight.bold,
                  color: kMaincolor,
                ),

              ),
              TextSpan(text: 'prepared by \n',
                style: GoogleFonts.rajdhani(
                  fontSize:16.sp,
                  fontWeight: FontWeight.bold,
                  color: kBlackcolor,
                ),

              ),
              TextSpan(text: '${widget.text2} ${widget.text3}',
                style: GoogleFonts.rajdhani(
                  fontSize:16.sp,
                  fontWeight: FontWeight.normal,
                  color: kExpertColor,
                ),

              ),

            ]
        ),
      )
    );
  }
}
