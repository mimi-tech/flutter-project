import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class RegistrationCompleted extends StatefulWidget {
  static String id = kRegistrationCompleted;

  @override
  _RegistrationCompletedState createState() => _RegistrationCompletedState();
}

class _RegistrationCompletedState extends State<RegistrationCompleted> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: kDarkGray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      minHeight: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: Center(
                      child: Text(
                        kThankYou_Completed,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kSize_25.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rajdhani',
                          color: kResendColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      minHeight: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: Center(
                      child: Text(
                        kClick_button,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kFont_size_18.sp,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          color: kWhiteColour,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.065,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        primary: kProfile,
                      ),
                      onPressed: () {
                        //TODO: Take the user to sparks landing screen.
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SparksLandingScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        kSpark_up,
                        style: TextStyle(
                          fontSize: kSize_25.sp,
                          fontFamily: 'Berkshire Swash',
                          fontWeight: FontWeight.bold,
                          color: kWhiteColour,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
