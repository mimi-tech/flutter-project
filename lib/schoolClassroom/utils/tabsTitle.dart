import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class TabsTitle extends StatelessWidget {
  TabsTitle({required this.title,required this.desc});
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.only(left:12.0),
          child: Text(title,
            style: GoogleFonts.rajdhani(fontSize: kFontSize14.sp,
              color:kBlackcolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        Padding(
          padding: const EdgeInsets.only(left:12.0),
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
              ),
              child: ReadMoreText(desc,

                trimLines: 2,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' ...',
                trimExpandedText: 'show less',
                style:GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kExpertColor,
                    fontSize:14.sp,
                  ),
                ),
              ),
            ),
          ),

        ),



      ],
    );
  }
}


class NoContentText extends StatelessWidget {
  NoContentText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:12.0),
      child: Text(title,
        style: GoogleFonts.rajdhani(fontSize:kFontsize.sp,
          color:kBlackcolor,
          fontWeight: FontWeight.bold,

        ),),
    );
  }
}


class ContentPrice extends StatelessWidget {
  ContentPrice({required this.price,required this.downloadCount});
  final String price;
  final String downloadCount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:12.0,right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(price,
            style: GoogleFonts.rajdhani(fontSize:kFontsize.sp,
              color:kBlackcolor,
              fontWeight: FontWeight.bold,

            ),),


          Text('Sold $downloadCount',
            style: GoogleFonts.rajdhani(fontSize:kFontsize.sp,
              color:kLightGreen,
              fontWeight: FontWeight.bold,

            ),),
        ],
      ),
    );
  }
}
