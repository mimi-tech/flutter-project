import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/seventh_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SchoolVerifyMobileScreen extends StatefulWidget {
  @override
  _SchoolVerifyMobileScreenState createState() =>
      _SchoolVerifyMobileScreenState();
}

class _SchoolVerifyMobileScreenState extends State<SchoolVerifyMobileScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _publishModal = false;

  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhitecolor,
      border: Border.all(color: kMaincolor),
      borderRadius: BorderRadius.circular(15),
    );
    return PinPut(
      autofocus: true,
      validator: Validator.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Constants.mobilePin = pine;
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
          pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kWhitecolor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ModalProgressHUD(
        inAsyncCall: _publishModal,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/company/sparksbg.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              children: <Widget>[
                //ToDo: The arrow for going back
                Logo(),
                //ToDo:company details
                SchoolConstants(
                  details: kSchDetails.toUpperCase(),
                ),
                //ToDo:hint text
                HintText(
                  hintText: kPin,
                ),
                //ToDo:company details
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: animatingBorders(),
                ),
                FlatButton(
                  color: kFbColor,
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        color: kWhitecolor,
                        fontSize: kErrorfont.sp,
                      ),
                    ),
                  ),
                  onPressed: () => _pinPutController.text = '',
                ),

                //ToDo: Company btn
                Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.6,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> goToNext() async {
    /*check if mobile number is not empty*/
    if (_pinPutController.text == '') {
      Fluttertoast.showToast(
          msg: kPinError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Constants.verificationId,
          smsCode: _pinPutController.text);

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {
        /*sign out the user inorder to auth the user with email and password*/
        _auth.signOut();
        registerUser(user);
      }
    }
  }

  void registerUser(User user) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SeventhScreen()));
  }
}
