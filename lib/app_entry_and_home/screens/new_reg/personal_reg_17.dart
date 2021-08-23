import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/email_validator.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:timer_builder/timer_builder.dart';

import '../profile_reg_complete.dart';

class PersonalReg17 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg17({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg17State createState() => _PersonalReg17State();
}

class _PersonalReg17State extends State<PersonalReg17> {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //TODO: Sparks main background.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/app_entry_and_home/sparksbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //TODO: A second faded background.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/app_entry_and_home/new_images/faded_spark_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //TODO: Content of this screen starts here.
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: SizedBox(
                            child: Image(
                              width: 200.0,
                              height: 80.0,
                              image: AssetImage(
                                'images/app_entry_and_home/new_images/sparks_new_logo.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "images/app_entry_and_home/new_images/title_bg.png",
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            kEmail_ver,
                            style: TextStyle(
                              fontSize: kFont_size_22.sp,
                              color: kReg_title_colour,
                              fontFamily: 'Rajdhani',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //TODO: Email verification logo.
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.25,
                            right: MediaQuery.of(context).size.width * 0.25,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.27,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "images/app_entry_and_home/new_images/email_verify.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.12,
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            right: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: kEmail_special_info +
                                          EmailValidator.obscureEmail(
                                              GlobalVariables.email!) +
                                          ". " +
                                          kEmail_special_info_part_2,
                                      style: TextStyle(
                                        color: kWhiteColour,
                                        fontFamily: 'Rajdhani',
                                        fontWeight: FontWeight.bold,
                                        fontSize: kFont_size_18.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: kSparks_universe,
                                      style: TextStyle(
                                        color: kProfile,
                                        fontFamily: 'Berkshire Swash',
                                        fontWeight: FontWeight.w200,
                                        fontSize: kFont_size_18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  kEmail_not_received,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontSize: kVerifying_size.sp,
                                      fontWeight: FontWeight.w600,
                                      color: kNo_email_colour,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              //TODO: Resend email verification
                              GestureDetector(
                                onTap: () {
                                  User user = FirebaseAuth.instance.currentUser!;
                                  user.sendEmailVerification();

                                  Fluttertoast.showToast(
                                      msg: kVerifyEmailSent,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kToastSuccessColour,
                                      textColor: kWhiteColour,
                                      fontSize: kFont_size_18.sp);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.25,
                                    right: MediaQuery.of(context).size.width *
                                        0.25,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kProfile,
                                  ),
                                  child: Center(
                                    child: Text(
                                      kResend_email,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontSize: kFont_size_18.sp,
                                          fontWeight: FontWeight.w900,
                                          color: kWhiteColour,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              //TODO: Display a circular next button.
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    User user =
                                        FirebaseAuth.instance.currentUser!;

                                    user.reload();

                                    if (user.emailVerified == true) {
                                      //TODO: update the key - emv - to true.
                                      DatabaseService(loggedInUserID: user.uid)
                                          .updateUserEmailVerification(
                                              GlobalVariables
                                                  .accountSelected["act"],
                                              true);
                                    }

                                    //TODO: Display registration completed screen to the user.
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return RegistrationCompleted();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kProfile,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 42.0,
                                        color: kWhiteColour,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
