import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/screens/encryption.dart';

import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/auth.dart';
import 'package:sparks/school_reg/screens/ninth_screen.dart';

import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparks/school_reg/screens/tenth_screen.dart';

import 'package:sparks/school_reg/screens/username_screen.dart';

class EighthScreen extends StatefulWidget {
  @override
  _EighthScreenState createState() => _EighthScreenState();
}

class _EighthScreenState extends State<EighthScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool _publishModal = false;

  String filePaths = 'schoolLogo/${DateTime.now()}';
  static var now = new DateTime.now();

  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  late UploadTask uploadTask;
  String? token;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DateTime ptc = DateTime.now();

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
              //ToDo:school login details
              SchoolConstants(
                details: kSchDetails.toUpperCase(),
              ),
              //ToDo:hint text
              HintText(
                hintText: kCompanyPassword,
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
                        obscureText: true,
                        onSaved: (String? value) {
                          Constants.companyPassword = value;
                        },
                        onChanged: (String value) {
                          Constants.companyPassword = value;
                        },
                        validator: Validator.validatePassword,
                        decoration: Constants.companyDecoration,
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: ScreenUtil().setHeight(70)),
              //ToDo:Enter Company username

              //ToDo:Enter school btn
              Indicator(
                nextBtn: () {
                  goToNext();
                },
                percent: 0.9,
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
      form.save();

      final encryptedPin = Encryption.encryptAes(Constants.companyPin);

      /*auth the user with email and password*/
      final newUser = firebaseAuth.createUserWithEmailAndPassword(
          email: Constants.companyEmail!.trim(),
          password: Constants.companyPassword!.trim());
      newUser.catchError((e) {
        String exception = Auth.getExceptionText(e);
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: exception,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      });
      newUser.then((value) async {
        try {
          setState(() {
            _publishModal = true;
          });

          /// send to fireBase storage
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          uploadTask = ref.putFile(
              Constants.logoImage!,
              SettableMetadata(
                contentType: "images" + '/' + "jpg",
              ));

          final TaskSnapshot downloadUrl = (await uploadTask);
          String url = (await downloadUrl.ref.getDownloadURL());
          User currentUser = FirebaseAuth.instance.currentUser!;

          //ToDo: sending to firebase
          currentUser.getIdToken().then((result) {
            //token = result.token;
            token = result;
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .collection('schoolUsers')
                .doc();
            documentReference.set({
              'id': currentUser.uid,
              'em': currentUser.email,
              'un': Constants.companyUserName,
              'name': Constants.companyName,
              'fn': Constants.firstName,
              'ln': Constants.lastName,
              'logo': url,
              'tk': token,
              'ex': DateTime.now().toString(),
              'adr': Constants.schoolAddress,
              'cty': Constants.selectedCountry,
              'st': Constants.selectedState,
              'city': Constants.companyCity,
              'str': Constants.companyStreet,
              'ph': Constants.companyPhone,
              'date': date,
              'vfy': currentUser.emailVerified ? true : false,
              'cpin': encryptedPin.base64,
              'schId': documentReference.id,
              'ts': ptc,
              'camp': Constants.isCampus ? true : false,
            });
            //ToDo:school username
            FirebaseFirestore.instance
                .collection('username')
                .doc(currentUser.uid)
                .set({'un': Constants.companyUserName, 'id': currentUser.uid});
            //ToDo:school username
            FirebaseFirestore.instance.collection('schoolPin').add({
              'spin': encryptedPin.base64,
              'un': Constants.companyUserName,
              'id': currentUser.uid
            });

            FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .set({
              'acct': FieldValue.arrayUnion([
                {'act': 'School', 'dp': true}
              ]),
            }, SetOptions(merge: true));

            setState(() {
              _publishModal = false;
            });

            if (currentUser.emailVerified) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TenthScreen()));
            } else {
              currentUser.sendEmailVerification();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NinthScreen()));
            }
            FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .set({
              'acct': FieldValue.arrayUnion([
                {'act': 'School', 'dp': false}
              ]),
            }, SetOptions(merge: true));
            setState(() {
              _publishModal = false;
            });
            if (currentUser.emailVerified) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TenthScreen()));
            } else {
              currentUser.sendEmailVerification();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NinthScreen()));
            }
          });
        } catch (e) {
          print(e);
          setState(() {
            _publishModal = false;
          });

          Fluttertoast.showToast(
              msg: kregisterError2,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      });
    }
  }
}
