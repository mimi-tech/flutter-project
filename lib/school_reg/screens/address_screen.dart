import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/school_reg/screens/third_screen.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool userNameVisible = false;
  bool _publishModal = false;
  TextEditingController unController = TextEditingController();

  String filePaths = 'companylogo/${DateTime.now()}';
  static var now = new DateTime.now();

  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  UploadTask? uploadTask;
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
              //ToDo:school details
              SchoolConstants(
                details: kSchDetails.toUpperCase(),
              ),

              //ToDo:hint text
              HintText(
                hintText: kSchAddress,
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
                        controller: unController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: kComplinecolor,
                        style: Constants.textStyle,
                        onSaved: (String? value) {
                          Constants.schoolAddress = value;
                        },
                        onChanged: (String value) {
                          Constants.schoolAddress = value;
                        },
                        validator: Validator.validateAddress,
                        decoration: Constants.companyDecoration,
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: ScreenUtil().setHeight(70)),
              //ToDo:school btn
              Indicator(
                nextBtn: () {
                  goToNext();
                },
                percent: 0.3,
              ),
            ],
          ),
        ),
      ),
    )));
  }

  Future<void> goToNext() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      unController.text.trim();

      form.save();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ThirdScreen()));
    }
  }
}
