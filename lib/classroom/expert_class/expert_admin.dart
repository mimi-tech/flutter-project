import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/expert_class/intro_screen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertAdminKey extends StatefulWidget {
  @override
  _ExpertAdminKeyState createState() => _ExpertAdminKeyState();
}

class _ExpertAdminKeyState extends State<ExpertAdminKey>
    with TickerProviderStateMixin {
  static Animation<Offset>? animation;
  late AnimationController animationController;
  TextEditingController _key = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;
  String? myKey;
  bool progress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                      color: kFbColor,
                      onPressed: () {},
                      child: Text('Apply',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          )))
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  spacer(),
                  Center(
                      child: SvgPicture.asset(
                    'images/classroom/unlock.svg',
                  )),
                  spacer(),
                  SlideTransition(
                    position: _offsetFloat,
                    child: Center(
                        child: Text(kExpertPinTwo,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kExpertColor,
                                fontSize: 22.sp,
                              ),
                            ))),
                  ),
                  spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextField(
                      controller: _key,
                      autofocus: true,
                      style: UploadVariables.uploadfontsize,
                      decoration: ExpertConstants.keyDecoration,
                      onChanged: (String value) {
                        myKey = value;
                      },
                    ),
                  ),
                  spacer(),
                  RichText(
                    text: TextSpan(
                        text: kApply,
                        style: GoogleFonts.rajdhani(
                            fontSize: kFontsize.sp,
                            color: kBlackcolor,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'apply',
                            style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                color: kExpertColor.withOpacity(0.5),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                  spacer(),
                  progress == true
                      ? PlatformCircularProgressIndicator()
                      : RaisedButton(
                          color: kExpertColor,
                          onPressed: () {
                            verifyUser();
                          },
                          child: Text('Verify',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kWhitecolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )))
                ],
              ),
            )));
  }

  Future<void> verifyUser() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    String? key;
    if ((myKey == null) || (myKey == '')) {
      Fluttertoast.showToast(
          msg: 'Please enter your key',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        progress = true;
        ExpertConstants.expertAdminDetails.clear();
      });

      try {
        await FirebaseFirestore.instance
            .collection('expertAdmin')
            .where('ky', isEqualTo: myKey)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            setState(() {
              key = result.data()['ky'];

              ExpertConstants.expertAdminDetails.add(result.data());
            });
          });
        });
        if (key == myKey) {
          setState(() {
            progress = false;
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => IntroductoryScreen()));
        } else {
          setState(() {
            progress = false;
          });
          Fluttertoast.showToast(
              msg: 'Access denied',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      } catch (e) {
        setState(() {
          progress = false;
        });
        print('this is the problem' + e.toString());
      }
    }
  }
}
//e46562d0-e59c-11ea-8e4a-216225608ddb expert

//0af3f110-e58d-11ea-a3c4-05ff387e170d company
