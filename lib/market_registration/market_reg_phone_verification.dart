import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/market_registration/m_reg_email_ver.dart';
import 'package:sparks/market_registration/market_reg_global_variables.dart';

class MarketRegPhoneVerification extends StatefulWidget {
  static String id = "market_phone_verification";

  @override
  _MarketRegPhoneVerificationState createState() =>
      _MarketRegPhoneVerificationState();
}

class _MarketRegPhoneVerificationState
    extends State<MarketRegPhoneVerification> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void showToastMessage(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white70,
    );
  }

  void verifyUserPhoneNumber() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: MarketRegGlobalVariables.phoneNumber!,
        timeout: const Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential).then((authResult) {
              if (authResult.user != null) {
                MarketRegGlobalVariables.isPhoneNumberVerified = true;
                MarketRegGlobalVariables.userPhoneId = authResult.user!.uid;

                _auth.signOut();
                Navigator.pushReplacementNamed(context, MarketRegEmailVer.id);
              }
            }).catchError((onError) {
              print(onError.toString());
            });
          } catch (e) {
            print(e);
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          showToastMessage(authException.message!);
        },
        codeSent: (stringValue, intValue) {
          /// Do something here...
        },
        codeAutoRetrievalTimeout: (String value) {
          /// Do something here...
        },);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: mediaQuery.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(56),
                            width: ScreenUtil().setWidth(56),
                            decoration: BoxDecoration(
                              color: Color(0xffFF502F),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: mediaQuery.width * 0.32,
                          color: Colors.transparent,
                          child: Image(
                            image: AssetImage(
                                'images/m_registration_images/sparks_logo.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: mediaQuery.height - 56.0,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enter code here",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        width: 180.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 48.0,
                              width: 180.0,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(8),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Resend code?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
