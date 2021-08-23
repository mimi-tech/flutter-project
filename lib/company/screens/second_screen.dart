import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/address_screen.dart';
import 'package:sparks/company/screens/username.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SecondScreen extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  SecondScreen({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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
              details: kCompanydetails.toUpperCase(),
            ),

            //ToDo:hint text
            HintText(
              hintText: kCompanyName,
            ),
            //ToDo:company details

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
                      validator: Validator.validateUserName,
                      decoration: Constants.companyDecoration,
                    ),
                  ],
                ),
              ),
            ),

            //ToDo: Company btn
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
          .push(MaterialPageRoute(builder: (context) => UsernameScreen()));
    }
  }
}
