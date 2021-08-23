import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/checkCampus.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/school_reg/screens/address_screen.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/school_reg/screens/username_screen.dart';

class SchoolSecondScreen extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  SchoolSecondScreen({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _SchoolSecondScreenState createState() => _SchoolSecondScreenState();
}

class _SchoolSecondScreenState extends State<SchoolSecondScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool userNameVisible = false;

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
              hintText: kSchName,
            ),

            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: kHorizontal),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      cursorColor: kComplinecolor,
                      style: Constants.textStyle,
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (String? value) {
                        Constants.companyName = value;
                      },
                      onChanged: (String value) {
                        Constants.companyName = value;
                      },
                      validator: Validator.validateName,
                      decoration: Constants.companyDecoration,
                    ),
                  ],
                ),
              ),
            ),

            //ToDo:Enter Company username

            //ToDo:Next Button
            Indicator(
              nextBtn: () {
                goToNext();
              },
              percent: 0.2,
            ),
          ],
        ),
      ),
    )));
  }

  void goToNext() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CheckCampus()));
    }
  }
}
