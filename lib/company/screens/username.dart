import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/address_screen.dart';
import 'package:sparks/company/screens/ninth_screen.dart';
import 'package:sparks/company/screens/second_screen.dart';
import 'package:sparks/company/screens/tenth_screen.dart';
import 'package:sparks/company/screens/third_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/auth.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool userNameVisible = false;
  bool _publishModal = false;
  TextEditingController _username = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String filePaths = 'companylogo/${DateTime.now()}';
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  UploadTask? uploadTask;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DateTime ptc = DateTime.now();
  String? token;

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
                hintText: kCompanyUserN,
              ),
              GestureDetector(
                  child: Text(
                    'logout',
                    style: TextStyle(color: kWhitecolor),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  }),

              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kHorizontal, vertical: kHorizontal),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _username,
                        autofocus: true,
                        cursorColor: kComplinecolor,
                        style: Constants.textStyle,
                        onSaved: (String? value) {
                          Constants.companyUserName = value;
                        },
                        onChanged: (String value) {
                          Constants.companyUserName = value;
                        },
                        validator: Validator.validateUserName,
                        decoration: Constants.companyDecoration,
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: ScreenUtil().setHeight(70)),
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
      ),
    )));
  }

  Future<void> goToNext() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      setState(() {
        _publishModal = true;
      });
      try {
        /*check if  username exist*/
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('username')
            .where('un', isEqualTo: _username.text.trim())
            .get();

        final List<DocumentSnapshot> documents = result.docs;

        if (documents.length == 1) {
          setState(() {
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: kUnExist,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        } else {
          setState(() {
            _publishModal = false;
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddressScreen()));
        }
      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }
  /* Navigator.of(context).push
        (MaterialPageRoute(builder: (context) => SecondScreen()));*/
}
