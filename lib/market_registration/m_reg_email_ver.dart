import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market_registration/m_reg_const.dart';
import 'package:sparks/market_registration/m_reg_strings.dart';
import 'package:sparks/market_registration/market_reg_global_variables.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';

class MarketRegEmailVer extends StatelessWidget {
  static String id = "m_reg_email_ver";

  /// Method to obscure the user's email address
  String obscureEmail(String userEmail) {
    String firstPart = userEmail.split("@").first;
    String obscureFirstPart =
        firstPart.replaceRange(4, (firstPart.length), "****");
    String lastPart = userEmail.split('@').last;
    String hashedEmail = obscureFirstPart + '@' + lastPart;
    return hashedEmail;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
              SizedBox(
                height: ScreenUtil().setHeight(24),
              ),
              Container(
                width: mediaQuery.width,
                height: ScreenUtil().setHeight(56),
                color: kFormHeaderColor.withOpacity(0.8),
                child: Center(
                  child: Text(
                    kMRegEmailVer,
                    style: kFormHeaderTextStyle,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: mediaQuery.width,
                  color: kFormBodyColor.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 88.0, left: 40.0, right: 40.0, bottom: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                            'images/m_registration_images/ver_email_icon.svg'),
                        Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: kMVerMsgOne,
                              style: KMEmailVerTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: obscureEmail(
                                      MarketRegGlobalVariables.email!),
                                  style: KMEmailVerTextStyle,
                                ),
                                TextSpan(
                                  text: kMVerMsgTwo,
                                  style: KMEmailVerTextStyle,
                                ),
                                TextSpan(
                                    text: 'Sparks Market',
                                    style: kMRegSparksMarket),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          color: kMarketPrimaryColor,
                          child: Text(
                            "Complete Registration",
                            style: kMRegResendEmailTextStyle,
                          ),
                          onPressed: () async {
                            /// Resetting the Market Registration Global Variables
                            MarketRegGlobalVariables.username = "";
                            MarketRegGlobalVariables.phoneNumber = "";
                            MarketRegGlobalVariables.email = "";
                            MarketRegGlobalVariables.password = "";
                            MarketRegGlobalVariables.isPhoneNumberVerified =
                                false;
                            MarketRegGlobalVariables.userPhoneId = "";

                            User user = FirebaseAuth.instance
                                .currentUser!;

                            String currentUserID = user.uid;

                            /// Check if the user's email is verified or not.
                            bool verifyingEmailAddr = user.emailVerified;
                            user.reload();

                            if (verifyingEmailAddr) {
                              /// Update the key - emv - to true.
                              DatabaseService(loggedInUserID: currentUserID)
                                  .updateUserEmailVerification(
                                  GlobalVariables.accountSelected["act"],
                                  verifyingEmailAddr);
                            }
                               /* .then((user) {
                              String currentUserID = user.uid;

                              /// Check if the user's email is verified or not.
                              bool verifyingEmailAddr = user.isEmailVerified;
                              user.reload();

                              if (verifyingEmailAddr) {
                                /// Update the key - emv - to true.
                                DatabaseService(loggedInUserID: currentUserID)
                                    .updateUserEmailVerification(
                                        GlobalVariables.accountSelected["act"],
                                        verifyingEmailAddr);
                              }
                            });*/

                            Navigator.pushReplacementNamed(
                                context, SparksLandingScreen.id);
                          },
                        ),
                      ],
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
