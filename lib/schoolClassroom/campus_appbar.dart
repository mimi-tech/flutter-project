import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class CampusAppbar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: kSappbarbacground,
        title: RichText(
          text: TextSpan(
              text:'${SchClassConstant.schDoc['name'].toString().toUpperCase()} \n',
              style: GoogleFonts.rajdhani(
                fontSize:16.sp,
                fontWeight: FontWeight.w700,
                color: kWhitecolor,
              ),

              children: <TextSpan>[
                TextSpan(text: '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                  style: GoogleFonts.rajdhani(
                    fontSize:16.sp,
                    fontWeight: FontWeight.normal,
                    color: kStabcolor1,
                  ),

                ),


              ]
          ),
        ),);

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}


class CampusAppbar2 extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('${SchClassConstant.schDoc['name'].toString().toUpperCase()}',
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: kWhitecolor,
            fontSize: kFontsize.sp,
          ),
        ),
      ),
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}



class CampusDeptAppbar extends StatelessWidget implements PreferredSizeWidget{
  CampusDeptAppbar({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: kSappbarbacground,
      title: RichText(
        text: TextSpan(
            text:'${SchClassConstant.schDoc['name'].toString().toUpperCase()} \n',
            style: GoogleFonts.rajdhani(
              fontSize:16.sp,
              fontWeight: FontWeight.w700,
              color: kWhitecolor,
            ),

            children: <TextSpan>[
              TextSpan(text: '$name Department',
                style: GoogleFonts.rajdhani(
                  fontSize:16.sp,
                  fontWeight: FontWeight.normal,
                  color: kStabcolor1,
                ),

              ),


            ]
        ),
      ),
    );

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}