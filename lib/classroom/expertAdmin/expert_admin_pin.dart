import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';

import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_class_page.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertAdminPin extends StatefulWidget {
  @override
  _ExpertAdminPinState createState() => _ExpertAdminPinState();
}

class _ExpertAdminPinState extends State<ExpertAdminPin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? key;
  bool _publishModal = false;
  static final nows = DateTime.now();

  static var date = new DateTime.now().toString();

  static var dateParse = DateTime.parse(date);

  static var formattedDate =
      "${dateParse.day}/${dateParse.month}/${dateParse.year}";

  static DateTime logOut = DateTime.now();
  var time = DateFormat("hh:mm:a").format(logOut);

  /*getting the different in login and logout time*/

  static var logOutTime = DateFormat("hh:mm").format(logOut);
  static var logInTime =
      DateFormat("hh:mm:a").format(ExpertAdminConstants.loginTime);

  static var format = DateFormat("hh:mm");
  static var one = format.parse(logInTime);
  static var two = format.parse(logOutTime);

  static var hours = two.difference(one);
  /* static int hoursCount = hours.inHours;
 static int minutesCount = hours.inMinutes;
*/

  /*getting the month name*/
  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobar',
    'Novermber',
    'December'
  ];
  var now = new DateTime.now();
  var currentMon = nows.month;

  var currentDate = new DateFormat("yyyy-MM-dd hh:mm:a").format(nows);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlatformScaffold(
            body: ModalProgressHUD(
      inAsyncCall: _publishModal,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'images/company/companyback.svg',
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'images/classroom/unlock.svg',
                  ),
                ),
              ),
            ],
          ),

          //SchoolConstants(details: kCourseKey.toUpperCase(),),
          //hint text
          Text(
            kExpertkey,
            style: GoogleFonts.rajdhani(
              fontSize: kFontsize.sp,
              color: kBlackcolor,
              fontWeight: FontWeight.bold,
            ),
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
                    cursorColor: kFbColor,
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kBlackcolor,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (String value) {
                      key = value;
                    },
                    validator: Validate.validateKey,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: kErrorfont.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rajdhani',
                          color: Colors.red,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: klistnmber,
                            style: BorderStyle.solid,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: klistnmber))),
                  ),
                ],
              ),
            ),
          ),
          CoursePublishBtn(
            title: kAccess,
            publish: () {
              accessKey();
            },
          ),
        ],
      ),
    )));
  }

  Future<void> accessKey() async {
    String? email;
    String? ky;
    User? currentUser = FirebaseAuth.instance.currentUser;

    final form = _formKey.currentState!;
    if (form.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      setState(() {
        _publishModal = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('expertAdmin')
            .where('ky', isEqualTo: key!.trim())
            .get()
            .then((value) {
          value.docs.forEach((result) async {
            email = result.data()['email'];
            ky = result.data()['ky'];
            ExpertAdminConstants.userData.add(result.data());

            result.reference.set(
                {
                  'cr': true,
                },
                SetOptions(
                    merge: true)); /*update the user details to online true*/
            /*try {
              if (ExpertAdminConstants.userData.isNotEmpty) {

                */ /*check if document exist*/ /*
                final snapShot = await FirebaseFirestore.instance
                    .collection("ExpertCompanyClass")
                    .doc(ExpertAdminConstants.userData[0]['id'])
                    .collection('ExpertCompanyCount').doc(
                    currentUser.uid)
                    .get();


                if (snapShot != null || snapShot.exists) {
                  // Document with id == docId doesn't exist.
                  FirebaseFirestore.instance
                      .collection("ExpertCompanyClass")
                      .doc(ExpertAdminConstants.userData[0]['id'])
                      .collection('ExpertCompanyCount').doc(
                      currentUser.uid).
                  setData({
                    'lg': true,
                    'li':logOut,

                  }, merge: true).catchError((e) {
                    print(e.toString());
                    setState(() {
                      _publishModal = false;
                    });
                    Fluttertoast.showToast(
                        msg: kAccessError,
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: kBlackcolor,
                        textColor: kFbColor);
                  });
                }
              }
            }catch(e){
              print(e.toString());
              setState(() {
                _publishModal = false;
              });
              Fluttertoast.showToast(
                  msg: kAccessError,
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: kBlackcolor,
                  textColor: kFbColor);


            }*/
          });
        });
        /*.whenComplete((){
          FirebaseFirestore.instance.collection('CourseAdmin').doc().setData({
           'lt':now,
            'wk':FieldValue.arrayUnion([{

              'logt':now,
              'date':UploadVariables.playlistUrl1,
              'logo':UploadVariables.playlistUrl2

            }],)

          });
        });*/

        if (ky == key) {
          setState(() {
            ExpertAdminConstants.loginTime = DateTime.now();
            ExpertAdminConstants.showLoginTime = currentDate;

            ExpertAdminConstants.currentUser = currentUser!.uid;

            _publishModal = false;
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ExpertPage()));
        } else {
          setState(() {
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: kAccessError,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
        /*checking if uid matches the key*/

      } catch (e) {
        // return CircularProgressIndicator();
      }
    }
  }
}

class Validate {
  static String? validateKey(String? value) {
    if (value!.isEmpty) {
      return "Please enter your access key";
    }

    return null;
  }
}

/*
'uid': currentUser.uid,
'li': currentDate,
'lit': one,
'yr': DateTime
    .now()
.year,
'mth': DateTime
    .now()
.month,
'month': months[currentMon - 1],
'day': DateTime
    .now()
.day,
'today': formattedDate,
'wk': DateTime
    .now()
.weekday,
'comId': ExpertAdminConstants.userData[0]['id'],
'name': ExpertAdminConstants.userData[0]['name'],
'fn': ExpertAdminConstants.userData[0]['fn'],
'email': ExpertAdminConstants.userData[0]['email'],
'pix': ExpertAdminConstants.userData[0]['pimg'],

'ts': now,

'cid': result.data['id'],*/
