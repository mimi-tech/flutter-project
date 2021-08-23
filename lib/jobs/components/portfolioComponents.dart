import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/subScreens/resume/singlePortfolio.dart';

class SecondImageShow extends StatelessWidget {
  const SecondImageShow({
    required this.imageUrl,
    this.colour,
  });
  final String? imageUrl;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
      height: ScreenUtil().setHeight(60.0),
      width: ScreenUtil().setWidth(70.0),
     child:  CachedNetworkImage(
       imageUrl: imageUrl!,
       placeholder: (context, url) =>
           CircularProgressIndicator(),
       errorWidget: (context, url, error) => Icon(Icons.error),
       fit: BoxFit.cover,
     ),

    );
  }
}





class MainSecondImageShow extends StatefulWidget {
  @override
  _MainSecondImageShowState createState() => _MainSecondImageShowState();
}

class _MainSecondImageShowState extends State<MainSecondImageShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft,
                    child: SinglePortfolio()));
              },
              child: SecondImageShow(
                  imageUrl: 'images/jobs/img1.png',
              ),
            ),
            SecondImageShow(
                imageUrl: 'images/jobs/img1.png'),
            SecondImageShow(
                imageUrl: 'images/jobs/img1.png'),
          ],
        ));
  }
}





class FirstImageShow extends StatelessWidget {
  FirstImageShow({
    required this.imageUrl,
  required this.description,
  this.colour,
  });

  final String? imageUrl;
  final String description;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[

          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: colour!, width: 4),
              //borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              height: ScreenUtil().setHeight(120.0),
              width: ScreenUtil().setWidth(190.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
               child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Text(description,
              style:GoogleFonts.rajdhani(
                textStyle:TextStyle(
                    fontSize:ScreenUtil().setSp(10),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),),),
          ),
        ],
      ),
    );
  }
}
