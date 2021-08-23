import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/eight_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';


class SeventhScreen extends StatefulWidget {
  @override
  _SeventhScreenState createState() => _SeventhScreenState();
}

class _SeventhScreenState extends State<SeventhScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

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
                      fit: BoxFit.cover,
                    )),

                child: Column(

                  children: <Widget>[

                    //ToDo: The arrow for going back

                    Logo(),
                    //ToDo:company details
                    SchoolConstants(details: kCompanydetails.toUpperCase(),),

                    //ToDo:hint text
                    HintText(hintText:kCompanyEmail),

                    Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:kHorizontal, vertical:kHorizontal),
                        child: Column(
                          children: <Widget>[

                            TextFormField(
                              autofocus: true,
                              cursorColor: kComplinecolor,
                              style: Constants.textStyle,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? value) {
                                Constants.companyEmail = value;
                              },
                              onChanged: (String value) {
                                Constants.companyEmail = value;
                              },
                              validator: Validator.validateEmail,
                              decoration: Constants.companyDecoration,
                            ),

                          ],
                        ),
                      ),
                    ),
                    //SizedBox(height: ScreenUtil().setHeight(70)),

                    //ToDo: Company btn
                    Indicator(nextBtn: (){goToNext();},percent: 0.7,),


                  ],
                ),
              ),
            )
        ));
  }

  void goToNext() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(Constants.companyEmail!);
      if (emailValid == true) {
        Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => EighthScreen()));
      }else{
        Fluttertoast.showToast(
            msg: kEmailInputError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }

  }
}