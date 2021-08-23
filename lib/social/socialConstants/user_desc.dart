import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UserDescription extends StatelessWidget {
  UserDescription({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.click,

  });
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final Function click;

  @override
  Widget build(BuildContext context) {
    return Container(

      width:MediaQuery.of(context).size.width,
      height:60,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end:
            Alignment(0.2, 0.8), // 10% of the width, so there are ten blinds.
            colors: [
              KTextfieldunderlinedarkcolor,
              kWhitecolor
            ], // red to yellow
            tileMode: TileMode.repeated,),
          color: KTextfieldunderlinedarkcolor,
          borderRadius:  BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),
            bottomRight: Radius.circular(kSocialVideoCurve),bottomLeft: Radius.circular(kSocialVideoCurve),

          )),

      child: ListTile(
        leading: GestureDetector(
          onTap:click as void Function(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kSocialVideoCurve),

            child: CachedNetworkImage(

              imageUrl: text1,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: 40.0,
              height: 40.0,

            ),
          ),
        ),

        title:Text('$text2 $text3',
          style: GoogleFonts.rajdhani(
            fontSize: kFontSize14.sp,
            color: klistnmber,
            fontWeight: FontWeight.bold,

          ),),
              subtitle:Text('$text4',
          style: GoogleFonts.rajdhani(
            fontSize: kFontSize14.sp,
            color: kLightGreen,
            fontWeight: FontWeight.bold,

          ),),

        trailing:  RaisedButton(onPressed: (){},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          color: kFbColor,
          child: Text(text5,
            style: GoogleFonts.rajdhani(
              fontSize:14.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),

      ),
    );
  }
}
