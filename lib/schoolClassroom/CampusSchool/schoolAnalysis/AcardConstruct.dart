import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ACardConstruct extends StatelessWidget {
  ACardConstruct({

    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,

  });
  final dynamic text1;
  final dynamic text2;
  final dynamic text3;
  final dynamic text4;
  final dynamic text5;
  final dynamic text6;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Text(text6.toString(),
                style: GoogleFonts.rajdhani(
                  decoration: TextDecoration.underline,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:kBlackcolor,
                    fontSize:kFontsize.sp,
                  ),
                )),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Live Class count',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kExpertColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),

                Text(text1.toString(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kIconColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),
              ],
            ),
            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text('Recorded video count',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kExpertColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),

                Text(text2.toString(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kIconColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),
              ],
            ),


            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text('Extra curricular video count',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kExpertColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),

                Text(text3.toString(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kIconColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),
              ],
            ),

            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text('Result uploaded count',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kExpertColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),

                Text(text4.toString(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kIconColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),
              ],
            ),

            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text('Assessment upload count',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kExpertColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),

                Text(text5.toString(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:kIconColor,
                        fontSize:kFontsize.sp,
                      ),
                    )),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
