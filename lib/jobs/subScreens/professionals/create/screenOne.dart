import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenTwo.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenOne extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenOne({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenOneState createState() =>
      _CreateProfessionalScreenOneState();
}

class _CreateProfessionalScreenOneState
    extends State<CreateProfessionalScreenOne> {
  final TextEditingController _professionalTitleController =
      TextEditingController();
  final TextEditingController _professionalLocationController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _professionalTitleController.dispose();
    _professionalLocationController.dispose();
    _aboutMeController.dispose();
    _phoneController.dispose();

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
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //ToDo: The arrow for going back
              Logo(),
              //ToDo:company details
              SchoolConstants(
                  details:
                      "Welcome ${GlobalVariables.loggedInUserObject.nm!["fn"]}"),

              //ToDo:hint text
              HintText(
                hintText: "Tell us your professional  title",
              ),
              //ToDo:company details

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _professionalTitleController,
                      cursorColor: kComplinecolor,
                      style: Constants.textStyle,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: Constants.companyDecoration,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "What is your current location?",
                ),
              ),
              //ToDo:company details

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _professionalLocationController,
                      cursorColor: kComplinecolor,
                      style: Constants.textStyle,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: Constants.companyDecoration,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Phone number",
                ),
              ),
              //ToDo:company details

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _phoneController,
                      cursorColor: kComplinecolor,
                      style: Constants.textStyle,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: Constants.companyDecoration,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Tell us more about you?",
                ),
              ),
              //ToDo:company details

              Column(
                children: <Widget>[
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Container(
                      height: ScreenUtil().setHeight(180.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        maxLines: 10,
                        autofocus: true,
                        controller: _aboutMeController,
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kLight_orange, width: 1.0),
                            ),
                            hintText: "Write about yourself here"),
                      ),
                    ),
                  ),
                ],
              ),

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (_professionalTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "Professional title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_professionalLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "Location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_phoneController.text == '') {
      Fluttertoast.showToast(
          msg: "phone number required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_aboutMeController.text == '') {
      Fluttertoast.showToast(
          msg: "Please tell us about you",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      ProfessionalStorage.professionalTitle =
          _professionalTitleController.text.toLowerCase();
      ProfessionalStorage.location =
          _professionalLocationController.text.toLowerCase();
      ProfessionalStorage.aboutMe = _aboutMeController.text.toLowerCase();
      ProfessionalStorage.phoneNumber = _phoneController.text;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateProfessionalScreenTwo()));
    }
  }
}
