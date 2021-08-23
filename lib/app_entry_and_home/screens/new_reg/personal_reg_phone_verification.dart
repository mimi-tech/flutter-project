import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/services/auth.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalPhoneVerification extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalPhoneVerification({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalPhoneVerificationState createState() =>
      _PersonalPhoneVerificationState();
}

class _PersonalPhoneVerificationState extends State<PersonalPhoneVerification> {
  var onTapRecognizer;

  bool hasError = false;
  String currentText = "";

  AuthService _authService = AuthService();
  FocusNode? otpNode;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        //TODO: Send an OTP to the user when the resend button is clicked and display a snack bar.
        await _authService.sendCodeToPhoneNumber(
          GlobalVariables.phoneNumber!,
          currentText,
        );

        //TODO; Display a toast.
        Fluttertoast.showToast(
            msg: kResendSnackBarMgs,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: kLight_orange,
            textColor: kWhiteColour,
            fontSize: kVerifying_size.sp);
      };

    otpNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 5,
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
                        kPersonal_phone_verification,
                        style: TextStyle(
                          fontSize: kFont_size_18.sp,
                          color: kReg_title_colour,
                          fontFamily: 'Rajdhani',
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      kPersonal_Phone_info + GlobalVariables.phoneNumber!,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontSize: kSize_14.sp,
                          fontWeight: FontWeight.w600,
                          color: kWhiteColour,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          obscureText: false,
                          autoFocus: true,
                          focusNode: otpNode,
                          animationType: AnimationType.fade,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: kTransparent,
                          textStyle: TextStyle(
                            color: kWhiteColour,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            borderRadius: BorderRadius.circular(5),
                            inactiveColor: kWhiteColour,
                            fieldHeight: 50,
                            fieldWidth: 40,
                          ),
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: kDid_not_receive,
                            style: TextStyle(
                              color: kWhiteColour,
                              fontSize: kFontSizeAnonynousUser.sp,
                            ),
                            children: [
                              TextSpan(
                                text: kResend,
                                recognizer: onTapRecognizer,
                                style: TextStyle(
                                  color: kResendColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: kSize_16.sp,
                                ),
                              ),
                            ]),
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
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //TODO: Display progress indicator.
                          PersonalReg().createState().createProgressIndicator(
                              widget.currentPage, context),
                          //TODO: Display a circular next button.
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () async {
                                //TODO: Verify the OTP sent by the user.
                                if (currentText.length == 6) {
                                  setState(() {
                                    otpNode!.unfocus();
                                  });

                                  //TODO: Send OTP to this phone number.
                                  await AuthService().sendCodeToPhoneNumber(
                                      GlobalVariables.phoneNumber!,
                                      currentText);

                                  if (GlobalVariables.phoneAuthException ==
                                      null) {
                                    //TODO: Go to the tenth page (Personal Account)
                                    widget.pageController.animateToPage(
                                      widget.currentPage.floor(),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    //TODO; Display a toast.
                                    Fluttertoast.showToast(
                                        msg: kPhoneNumberVerificationFailed,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: kLight_orange,
                                        textColor: kWhiteColour,
                                        fontSize: kVerifying_size.sp);
                                  }
                                } else {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: kEmptyOTPErrMgs,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kVerifying_size.sp);
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
