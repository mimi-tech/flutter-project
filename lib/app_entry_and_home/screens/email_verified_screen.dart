import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class VerifyEmail extends StatelessWidget {
  static String id = kVerify_email;

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: SizedBox(
                    child: Image(
                      width: 200.0,
                      height: 100.0,
                      image: AssetImage(
                        'images/app_entry_and_home/brand.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.68,
                        child: Image.asset(
                          'images/app_entry_and_home/sparks_email_verify_bg.png',
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.14,
                              right: MediaQuery.of(context).size.width * 0.14,
                            ),
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: kCongratulation,
                                  style: TextStyle(
                                    color: kResendColor,
                                    fontSize: kSize_25.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rajdhani',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: kSuccess_message,
                                      style: TextStyle(
                                        color: kWhiteColour,
                                        fontSize: kSize_16.sp,
                                        fontFamily: 'Rajdhani',
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.14,
                              right: MediaQuery.of(context).size.width * 0.14,
                            ),
                            height: MediaQuery.of(context).size.height * 0.02,
                            child: Divider(
                              color: kFooterLabelTextColour,
                              thickness: 0.7,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.14,
                              right: MediaQuery.of(context).size.width * 0.14,
                            ),
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Center(
                              child: Text(
                                kClick_verify_phone_number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kWhiteColour,
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: kSize_16.sp,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            child: Center(
                              child: Icon(
                                Icons.arrow_downward,
                                color: kWhiteColour,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  //TODO: Do something when verify phone number button is clicked.
                                },
                                child: Image.asset(
                                  'images/app_entry_and_home/verify_email_btn.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
