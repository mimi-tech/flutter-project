import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class CallPageAppBar extends StatefulWidget with PreferredSizeWidget {
  CallPageAppBar({required this.courseName, required this.topic, required this.timer});
  final String courseName;
  final String topic;
  final String timer;

  @override
  _CallPageAppBarState createState() => _CallPageAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _CallPageAppBarState extends State<CallPageAppBar> {
  bool refreshColor = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBlackcolor,
      automaticallyImplyLeading: false,
      //leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: kWhitecolor,), onPressed:(){Navigator.pop(context);}),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          SizedBox(width: 15,),
          Flexible(
            child: Column(

              children: [

                Text(widget.courseName,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kWhitecolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),

                ),

                Text(widget.topic,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kWhitecolor,
                      fontSize: kFontSize14.sp,
                    ),
                  ),

                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.timer),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.timer,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: kResendColor,
                          fontSize:12.sp,
                        ),
                      ),

                    ),
                  ],
                ),

              ],
            ),
          ),

          IconButton(icon: Icon(Icons.refresh,color: refreshColor?kMaincolor:kWhitecolor,), onPressed:(){setState(() {
            refreshColor = !refreshColor;
          });}),
        ],
      ),
    );
  }
}
