import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/second_screen.dart';
import 'package:sparks/company/screens/sixth_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with TickerProviderStateMixin {
  bool userNameVisible = false;

  bool _publishModal = false;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

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
      fieldsCount: 4,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Constants.companyPin = pine;
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
                details: kCompanydetails.toUpperCase(),
              ),

              //ToDo:hint text
              HintText(
                hintText: kCompanyPin,
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
                percent: 0.15,
              ),
            ],
          ),
        ),
      ),
    )));
  }

  Future<void> goToNext() async {
    if (Constants.companyPin == null) {
      Fluttertoast.showToast(
          msg: kPinExist,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SixthScreen()));
    }
  }
}
