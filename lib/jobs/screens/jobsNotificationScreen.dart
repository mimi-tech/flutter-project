import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class JobsNotification extends StatefulWidget {
  @override
  _JobsNotificationState createState() => _JobsNotificationState();
}

class _JobsNotificationState extends State<JobsNotification> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Container(
                  child: Text(
                    "Notifications",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              titleSpacing: 0.0,
              backgroundColor: kLight_orange,
              automaticallyImplyLeading: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              actions: <Widget>[],
            ),
          backgroundColor: Colors.black45,
            body: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Jobs Notification Screen",
                    style: GoogleFonts
                        .rajdhani(
                      textStyle: TextStyle(
                          fontSize:
                          ScreenUtil()
                              .setSp(
                              16.0),
                          fontWeight:
                          FontWeight
                              .bold,
                          color: Colors
                              .white),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
