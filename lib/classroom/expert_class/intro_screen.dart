import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/expert_class/class_details.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class IntroductoryScreen extends StatefulWidget {
  @override
  _IntroductoryScreenState createState() => _IntroductoryScreenState();
}

class _IntroductoryScreenState extends State<IntroductoryScreen>
    with TickerProviderStateMixin {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  static late Animation<Offset> animation;
  late AnimationController animationController;

  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });

    //ToDo:second animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: kBlackcolor, size: 20.0),
              backgroundColor: kWhitecolor,
              elevation: 0,
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: SlideTransition(
                position: animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(kSparksExpertClass,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kFbColor,
                              fontSize: 30.sp,
                            ),
                          )),
                    ),
                    Center(
                      child: Text(
                          'Welcome  ${GlobalVariables.loggedInUserObject.nm!['fn']}!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: 30.sp,
                            ),
                          )),
                    ),
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    Center(
                      child: Text('You are a genuis in the ⚡️ of programming',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            letterSpacing: 2.0,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: 30.sp,
                            ),
                          )),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                            color: kFbColor,
                            onPressed: () {},
                            child: Text('Tips',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ))),
                        RaisedButton(
                            color: kExpertColor,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.topToBottom,
                                      child: ClassDetails()));
                            },
                            child: Text(kButton_next,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
