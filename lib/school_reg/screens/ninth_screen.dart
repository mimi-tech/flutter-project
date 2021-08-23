import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/tenth_screen.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class NinthScreen extends StatefulWidget {
  @override
  _NinthScreenState createState() => _NinthScreenState();
}

class _NinthScreenState extends State<NinthScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;
  Timer? _timer;

  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();
    Future(() async {
      User currentUser = FirebaseAuth.instance.currentUser!;
      Constants.schoolCurrentUser = currentUser.uid;
    });
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();
        var user = FirebaseAuth.instance.currentUser!;
        if (user.emailVerified) {
          setState(() {
            Constants.schoolCurrentUser = null;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => TenthScreen(),
              ),
              (route) => false,
            );
          });
          timer.cancel();
        }
      });
    });

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
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
          body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/company/sparksbg.png'),
            fit: BoxFit.cover,
          )),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Constants.schoolCurrentUser)
                  .collection('schoolUsers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: ProgressIndicatorState(),
                  );
                } else {
                  print(Constants.schoolCurrentUser);

                  final testingOne =
                      snapshot.data!.docs as List<Map<String, dynamic>>;

                  var users = testingOne[0]['em'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  'images/company/companyback.svg',
                                )),
                          ),

                          SlideTransition(
                            position: animation,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset(
                                  'images/company/sparkslogo.svg',
                                ),
                              ),
                            ),
                          ),

                          //ToDo:company login details

                          Container(
                            margin: EdgeInsets.symmetric(vertical: kComspace),
                            width: double.infinity,
                            height: ScreenUtil().setHeight(50.0),
                            color: kCdetailsbgcolor.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                kCompanyEmailV.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: kCompanydetailsdimens.sp,
                                  color: kCdetailstxtcolor,
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //ToDo:displaying the verificaton logo

                      Container(
                        child: SvgPicture.asset(
                          'images/company/verificationlogo.svg',
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: kCompanyVerification +
                                  users.substring(0, 2) +
                                  "*****" +
                                  'gmail.com' +
                                  " " +
                                  kCompanyVerification2,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: kWhitecolor,
                                fontFamily: 'Rajdhani',
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: kCompanyVerification3,
                                  style: GoogleFonts.berkshireSwash(
                                    fontSize: kCompanydetailsdimens.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kMaincolor,
                                  ),
                                )
                              ]),
                        ),
                      ),

                      SizedBox(height: ScreenUtil().setHeight(20)),

                      Text(
                        kCompanyResend,
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          fontWeight: FontWeight.w700,
                          color: kComapnylocation,
                        ),
                      ),

                      RaisedButton(
                        color: kFbColor,
                        child: Text(
                          kCompanyResendbtn,
                          style: GoogleFonts.rajdhani(
                            fontSize: kFontsize.sp,
                            fontWeight: FontWeight.w700,
                            color: kWhitecolor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () async {
                          User currentUser = FirebaseAuth.instance.currentUser!;
                          currentUser.sendEmailVerification();
                          Fluttertoast.showToast(
                              msg: 'Email verification sent successfully',
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: kBlackcolor,
                              textColor: Colors.green);
                        },
                      ),

                      SizedBox(height: ScreenUtil().setHeight(kCompspace2)),
                    ],
                  );
                }
              }),
        ),
      )),
    );
  }
}
