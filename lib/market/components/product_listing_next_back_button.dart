import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListingNextBackButton extends StatelessWidget {
  final Function onTap;
  final String buttonName;

  ProductListingNextBackButton(
      {required this.onTap, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Color(0xffFF9480),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          buttonName,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: ScreenUtil().setSp(18),
            ),
          ),
        ),
      ),
    );
  }
}
