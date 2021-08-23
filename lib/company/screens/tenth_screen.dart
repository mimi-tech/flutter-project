import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/home_appBar.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/screens/jobs.dart';

class TenthScreen extends StatefulWidget {
  @override
  _TenthScreenState createState() => _TenthScreenState();
}

class _TenthScreenState extends State<TenthScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInCirc,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: kCompanysuccesscolor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: animation,
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
              ),
              // SizedBox(height: ScreenUtil().setHeight(80) ,),
              Center(
                child: Text(
                  kCompanySuccess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: kSize_32.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rajdhani',
                    color: kResendColor,
                  ),
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: kCompanyClick,
                    style: TextStyle(
                      fontSize: kCompanydetailsdimens.sp,
                      color: kCompanysuccesstext,
                      fontFamily: 'Rajdhani',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: kCompanySparksup,
                        style: GoogleFonts.rajdhani(
                          fontSize: kCompanydetailsdimens.sp,
                          fontWeight: FontWeight.w700,
                          color: kWhitecolor,
                        ),
                      ),
                      TextSpan(
                        text: kCompanyClick2,
                        style: GoogleFonts.rajdhani(
                          fontSize: kCompanydetailsdimens.sp,
                          fontWeight: FontWeight.w700,
                          color: kCompanysuccesstext,
                        ),
                      )
                    ]),
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
                    //TODO: Send the user to the home screen.
                    UserStorage.isFromCompanyPage = true;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Jobs(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Sparks Up',
                    style: GoogleFonts.berkshireSwash(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                      color: kWhitecolor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
