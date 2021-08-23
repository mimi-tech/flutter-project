import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/school_reg/screens/address_screen.dart';
import 'package:sparks/school_reg/screens/auth.dart';
import 'package:sparks/school_reg/screens/ninth_screen.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/school_reg/screens/tenth_screen.dart';

class SchoolFirstName extends StatefulWidget {
  @override
  _SchoolFirstNameState createState() => _SchoolFirstNameState();
}

class _SchoolFirstNameState extends State<SchoolFirstName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool userNameVisible = false;
  bool _publishModal = false;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  String filePaths = 'schoolLogo/${DateTime.now()}';
  static var now = new DateTime.now();

  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  UploadTask? uploadTask;
  String? token;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DateTime ptc = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
  }

  void setUp() {
    if (GlobalVariables.loggedInUserObject.id != null) {
      setState(() {
        _firstName.text = GlobalVariables.loggedInUserObject.nm!['fn']!;
        _lastName.text = GlobalVariables.loggedInUserObject.nm!['ln']!;
      });
    }
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
                        child: Column(children: <Widget>[
                          //ToDo: The arrow for going back
                          Logo(),
                          //ToDo:school details
                          SchoolConstants(
                            details: kSchDetails.toUpperCase(),
                          ),

                          //ToDo:hint text
                          HintText(
                            hintText: kSchUsername1,
                          ),
                          Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kHorizontal,
                                  vertical: kHorizontal),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _firstName,
                                    autofocus: true,
                                    readOnly:
                                        GlobalVariables.loggedInUserObject.id ==
                                                null
                                            ? false
                                            : true,
                                    cursorColor: kComplinecolor,
                                    style: Constants.textStyle,
                                    onSaved: (String? value) {
                                      Constants.firstName = value;
                                    },
                                    onChanged: (String value) {
                                      Constants.firstName = value;
                                    },
                                    validator: Validator.validateUsersName,
                                    decoration: Constants.companyDecoration,
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  HintText(
                                    hintText: kSchUsername2,
                                  ),
                                  TextFormField(
                                    controller: _lastName,
                                    autofocus: true,
                                    readOnly:
                                        GlobalVariables.loggedInUserObject.id ==
                                                null
                                            ? false
                                            : true,
                                    cursorColor: kComplinecolor,
                                    style: Constants.textStyle,
                                    onSaved: (String? value) {
                                      Constants.lastName = value;
                                    },
                                    onChanged: (String value) {
                                      Constants.lastName = value;
                                    },
                                    validator: Validator.validateUsersName,
                                    decoration: Constants.companyDecoration,
                                  ),

                                  //SizedBox(height: ScreenUtil().setHeight(70)),
                                ],
                              ),
                            ),
                          ),

                          //ToDo:school btn
                          Indicator(
                            nextBtn: () {
                              goToNext();
                            },
                            percent: 0.2,
                          ),
                        ]))))));
  }

  Future<void> goToNext() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _publishModal = true;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddressScreen()));
    }
  }
}
