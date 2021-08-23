import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
//import 'package:timer_builder/timer_builder.dart';

class VerifyingEmailAddress extends StatefulWidget {
  static String id = kVerifying_email_address;

  @override
  _VerifyingEmailAddressState createState() => _VerifyingEmailAddressState();
}

class _VerifyingEmailAddressState extends State<VerifyingEmailAddress> {
  //TODO: Make an instance of the authService class.

  //TODO: This function is called every five seconds. This is done to check if the user's email has been verified or not.
  Future<bool?> _callMethod() async {
    bool? hasBeenVerified;
    bool? userEmailVerified;

    User user = FirebaseAuth.instance.currentUser!;
    //TODO: Fetches the updated user instance from the server.
    user.reload();

    if (user != null) {
      if (user.emailVerified) {
        userEmailVerified = user.emailVerified;
      }
      userEmailVerified == true
          ? hasBeenVerified = true
          : hasBeenVerified = false;
    }

    return hasBeenVerified;
  }

  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/app_entry_and_home/sparksbg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Image(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.14,
                      image: AssetImage(
                        'images/app_entry_and_home/brand.png',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            kEmail_Verification,
                            style: TextStyle(
                              fontSize: kEmail_Verification_Size.sp,
                              color: kWhiteColour,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            kCheck_mail,
                            style: TextStyle(
                              color: kWhiteColour,
                              fontFamily: 'Rajdhani',
                              fontSize: kVerifying_size.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      /*Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15,

                        //TODO: Do something when _callMethod() is false.
                        child: FutureBuilder<bool>(
                          future: _callMethod(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {

                            if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                                (snapshot.data == false)) {
                              return Center(
                                child: SpinKitDoubleBounce(
                                  color: kFormLabelColour,
                                ),
                              );
                            }

                            //TODO: Do something when _callMethod() is true.
                            else if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                                (snapshot.data == true)) {
                              return CircleAvatar(
                                backgroundColor: kResendColor,
                                child: Icon(
                                  Icons.done,
                                  size: ScreenUtil().setSp(
                                    kIcon_done_size,
                                    allowFontScalingSelf: true,
                                  ),
                                ),
                              );
                            }

                            return Center(
                              child: Text(''),
                            );
                          },
                        ),
                      ),*/
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      /* Container(
                        //TODO: Do something when _callMethod() is false.
                        child: FutureBuilder<bool>(
                          future: _callMethod(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {

                            if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                                (snapshot.data == false)) {
                              return Text(
                                kVerifying,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  color: kWhiteColour,
                                  fontSize: kVerifying_size.sp,
                                ),
                              );
                            }

                            //TODO: Do something when _callMethod() is true.
                            else if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                                (snapshot.data == true)) {
                              return Text(
                                kEmail_Verification_success,
                                style: TextStyle(
                                  color: kResendColor,
                                ),
                              );
                            }

                            return Center(
                              child: Text(''),
                            );
                          },
                        ),
                      ),*/
                    ],
                  ),
                ),
                //TODO: Resend email verification to the user's email.
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
                  child: Text(
                    "Can't find verification email? Tap on RESEND",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.apply(
                          color: kWhiteColour,
                        ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.08,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      User user = FirebaseAuth.instance.currentUser!;
                      //TODO: Fetches the updated user instance from the server.
                      user.reload();

                      if (user.emailVerified == true) {
                        //TODO: Update user's email verification to true.
                        await DatabaseService(loggedInUserID: accountGateWay.id)
                            .updateUserEmailVerification(
                                GlobalVariables.accountSelected["act"], true);

                        //TODO: Take the user to sparks landing screen.
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SparksLandingScreen();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: kEmailNotVerifiedErrMgs,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: kLight_orange,
                            textColor: kWhiteColour,
                            fontSize: kSize_16.sp);
                      }
                    },
                    child: Image.asset(
                      'images/app_entry_and_home/next.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
