import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PhotoView extends StatelessWidget {
  static const String id = kPhoto_view;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColour,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: kProfile,
          ),
          title: Text(
            kPhoto_gallery,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontSize: kFont_size_18.sp,
                color: kProfile,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: GlobalVariables.gallery!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: GlobalVariables.gallery![index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
