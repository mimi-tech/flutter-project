import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ReactionText extends StatelessWidget {
  ReactionText({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,

  });
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(height: 10,),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text4,

                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: klistnmber,
                    fontSize:kFontsize.sp,
                  ),
                ),
              ),

              Text(text5,

                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: klistnmber,
                    fontSize:kFontsize.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 2,color: klistnmber,),
        ListTile(

          leading:CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 32,
            child: ClipOval(

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
          title: Text(text2,

            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize:kFontsize.sp,
              ),
            ),
          ),


          subtitle: Text(text3,

            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize:kFontsize.sp,
              ),
            ),
          ),

          trailing: RaisedButton(
            onPressed: (){},
            color:kFbColor,
            child: Text(kFollow,

              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kWhitecolor,
                  fontSize:kFontsize.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
