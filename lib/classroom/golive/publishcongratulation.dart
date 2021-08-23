import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/home_appBar.dart';
//import 'package:sparks/classroom/contents/live/content_live_post.dart';

import 'package:sparks/app_entry_and_home/screens/create_profile.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PublishSuccess extends StatefulWidget {
  PublishSuccess({required this.title});
  final String title;
  @override
  _PublishSuccessState createState() => _PublishSuccessState();
}

class _PublishSuccessState extends State<PublishSuccess> {
  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          backgroundColor: kDarkBlue,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kProfile,
                    ),
                    child: Icon(
                      Icons.check,
                      size: kSize_70.sp,
                      color: kResendColor,
                    ),
                  ),
                ),
                // SizedBox(height: ScreenUtil().setHeight(80) ,),
                Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kSize_32.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rajdhani',
                      color: kResendColor,
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(70),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: kHorizontal, vertical: 24.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    color: kProfile,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreateSparksProfile(
                            accountName: kPersonalAccountType,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      kSessionClose,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                        color: kWhiteColour,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
