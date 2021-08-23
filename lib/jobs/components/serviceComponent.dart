import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/colors/colors.dart';



class ServiceBoxContent extends StatelessWidget {
  const ServiceBoxContent({
    required this.screenData,
    this.headerText,
    this.textContent,
    this.readMore,
    this.boxBg,
  }) ;

  final Size screenData;
  final String? headerText;
  final String? textContent;
  final String? readMore;
  final Color? boxBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(300.0),
      width: screenData.width * 0.95,
      color: boxBg,
      margin: EdgeInsets.fromLTRB(
          0.0, 10.0, 0.0, 10.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, 30.0, 0.0, 30.0),
            child: Text(
              headerText!,
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: kAboutMiddleTextColor4),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                20.0, 0.0, 20.0, 0.0),
            child: RichText(text:
            TextSpan(
              text: textContent,
              style: TextStyle(
                fontFamily: "Rajdhani",
                fontSize: 25.0,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: readMore,
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kMore),
                ),
              ]
            ),
            ),
          ),


        ],
      ),

    );
  }
}
