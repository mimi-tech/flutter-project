import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/encryption.dart';
import 'package:sparks/company/screens/ninth_screen.dart';
import 'package:sparks/company/screens/seventh_screen.dart';
import 'package:sparks/company/screens/tenth_screen.dart';
import 'package:sparks/company/screens/verify_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SixthScreen extends StatefulWidget {
  @override
  _SixthScreenState createState() => _SixthScreenState();
}

class _SixthScreenState extends State<SixthScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String filePaths = 'companylogo/${DateTime.now()}';
  static var now = new DateTime.now();

  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  late UploadTask uploadTask;
  bool _publishModal = false;
  String _countryCode = '';
  String? phoneNumber;
  String? smsCode;
  String? verificationCode;
  DateTime ptc = DateTime.now();
  String? token;
  String? userName;

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
              Logo(),
              //ToDo:school details
              DetailsLogo(),
              //ToDo:hint text
              HintText(hintText: kCompanymobile),

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
                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {
                          Constants.companyPhone = value;
                        },
                        onChanged: (String value) {
                          Constants.companyPhone = value;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: Validator.validateNumber,
                        decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              textStyle: TextStyle(
                                fontSize: kErrorfont.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rajdhani',
                                color: kWhitecolor,
                              ),
                              onInit: (code) {
                                _countryCode = code.toString();
                              },
                              onChanged: (code) {
                                _countryCode = code.toString();
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'NG',
                              favorite: ['+234', 'NG'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            errorStyle: TextStyle(
                              fontSize: kErrorfont.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                              color: Colors.red,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kComplinecolor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kComplinecolor))),
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: ScreenUtil().setHeight(70)),
              //ToDo:Enter Company username

              //ToDo:school next button
              Indicator(
                nextBtn: () {
                  goToNext();
                },
                percent: Constants.companyCurrentUser == null ? 0.7 : 1.0,
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
      //ToDo:Check if user already has an account

      User? currentUser = FirebaseAuth.instance.currentUser;

      //hash password

      final encryptedPin = Encryption.encryptAes(Constants.companyPin);

      if (currentUser == null) {
        //send sms to phone number

        try {
          //Auth the user
          FirebaseAuth _auth = FirebaseAuth.instance;
          _auth.verifyPhoneNumber(
            phoneNumber: _countryCode + Constants.companyPhone!,
            timeout: Duration(seconds: 120),
            verificationCompleted: (AuthCredential credential) async {
              UserCredential result =
                  await _auth.signInWithCredential(credential);
              User? user = result.user;

              if (user != null) {
                /*sign out the user inorder to auth the user with email and password*/
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SeventhScreen()));
              }
            },
            verificationFailed: (FirebaseAuthException exception) {
              Fluttertoast.showToast(
                  msg: exception.message!,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: kBlackcolor,
                  textColor: kFbColor);
            },
            codeSent: (String verificationCode, [int? forceCodeResend]) {
              Constants.verificationId = verificationCode;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerifyMobileScreen()));
            },
            codeAutoRetrievalTimeout: (String testingOne) {
              print(testingOne);
            },
          );
        } on PlatformException catch (e) {
          print(e.toString());
        }
        /*Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => SeventhScreen()));*/
      } else {
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

          //ToDo: sending to firebase

          currentUser.getIdToken().then((result) {
            //token = result.token;
            token = result;
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .collection('company')
                .doc();
            documentReference.set({
              'id': currentUser.uid,
              'em': currentUser.email,
              'un': Constants.companyUserName!.trim(),
              'name': Constants.companyName,
              'logo': url,
              'cty': Constants.selectedCountry,
              'st': Constants.selectedState,
              'city': Constants.companyCity,
              'str': Constants.companyStreet,
              'ph': Constants.companyPhone,
              'date': DateTime.now().toString(),
              'tk': token,
              'ex': DateTime.now().toString(),
              'adr': Constants.companyAddress,
              'vfy': currentUser.emailVerified ? true : false,
              'cpin': encryptedPin.base64,
              'comp_id': documentReference.id,
              'ts': ptc,
            });

            //ToDo:Company pin
            FirebaseFirestore.instance.collection('companyPin').add({
              'cpin': encryptedPin.base64,
              'id': currentUser.uid,
              'un': Constants.companyUserName!.trim(),
            });
            FirebaseFirestore.instance
                .collection('username')
                .doc(currentUser.uid)
                .set({
              'un': Constants.companyUserName!.trim(),
              'id': currentUser.uid
            });
            //ToDo:update account type

            FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .set({
              //'acct': tags.contains('school')
              // ? FieldValue.arrayUnion([])
              'acct': FieldValue.arrayUnion([
                {'act': 'Company', 'dp': true}
              ]),
            }, SetOptions(merge: true));
            /*  DocumentReference docRef = FirebaseFirestore.instance.collection(
              'users').doc(currentUser.uid);
          DocumentSnapshot doc = await docRef.get();
          List tags = doc.data['acct'];
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .setData({
            //'acct': tags.contains('school')
            // ? FieldValue.arrayUnion([])
            'acct': FieldValue.arrayUnion([{'act':'Company',
              'dp':false
            }]),

          },merge: true);*/

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
      }
    }
  }
}
